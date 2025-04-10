//
//  BatterySDK.swift
//  BatterySDK
//
//  Created by Dylan Le Hir on 3/6/25.
//

import UIKit
import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk
import OpenTelemetryProtocolExporterGrpc
import GRPC
import NIO

public class BatteryManager {
    // MARK: - Private properties
    private var meter: StableMeter?
    private var doubleGaugeObservable: ObservableDoubleGauge?

    // MARK: - Public properties
    
    /// The default instance of BatteryManager
    @MainActor public static let shared = BatteryManager()
    
    // MARK: - Private methods
    
    private init() {}

    /// Configures the Battery SDK with the specified settings.
    ///
    /// This method sets up the necessary infrastructure for collecting and exporting battery metrics.
    /// It must be called before starting ``startMonitoring()``, and should typically be invoked once during
    /// your application's initialization phase.
    ///
    /// - Parameter configuration: A ``Configuration`` object containing the host and port information
    ///   for the metrics exporter.
    /// - Throws: ``BatterySDKError/configurationError(message:)`` if the meter couldn't be created
    ///
    /// ### Usage Example
    /// ```swift
    /// let configuration = BatteryManager.Configuration(host: "example.com", port: .gRPC)
    /// try BatteryManager.shared.configure(configuration) { OpenTelemetry.instance }
    /// try BatteryManager.shared.startMonitoring()
    /// ```
    ///
    /// After configuration is complete, you can safely call ``startMonitoring()`` to begin
    /// recording battery metrics.
    @MainActor public func configure(_ configuration: Configuration, _ openTelemetryInstancer: () -> OpenTelemetry) throws(BatterySDKError)  {
        // Enable the battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Create the connection
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let exporterChannel = ClientConnection.insecure(group: group)
            .connect(host: configuration.host,
                     port: configuration.port.value)
        
        // Create the meter provider
        let meterProvider = StableMeterProviderBuilder()
            .registerView(selector: InstrumentSelector.default,
                          view: StableView.default)
            .registerMetricReader(reader: StablePeriodicMetricReaderSdk.default(channel: exporterChannel))
            .build()
        
        // Register the provider
        OpenTelemetry.registerStableMeterProvider(meterProvider: meterProvider)
        
        // Create stable meter
        let meter = openTelemetryInstancer()
            .stableMeterProvider?
            .meterBuilder(name: .meterName)
            .build()

        guard let meter else { throw .configurationError(message: "Could not find stable meter provider") }
        self.meter = meter
    }
    
    /// Starts monitoring the device’s battery level and reports metrics using OpenTelemetry.
    ///
    /// This method initializes the necessary telemetry instruments and begins observing the battery level,
    /// device name, and battery state. These metrics are recorded periodically and made available through
    /// the provided OpenTelemetry instance.
    ///
    /// Before calling this method, ensure that your you called the ``configure(_:_:)``
    /// method. Failing to do so will result in a ``BatterySDKError/stableMeterProviderNotFound`` error.
    ///
    /// - Parameter openTelemetry: An initialized instance of ``OpenTelemetry`` used for metrics reporting.
    /// - Throws: ``BatterySDKError/monitoringError(message:)`` if the meter cannot be find due to misconfiguration.
    ///
    /// ### Usage Example
    /// ```swift
    /// let configuration = BatteryManager.Configuration(host: "example.com", port: .gRPC)
    /// try BatteryManager.shared.configure(configuration) { OpenTelemetry.instance }
    /// try BatteryManager.shared.startMonitoring()
    /// ```
    ///
    /// After calling this method, the SDK will automatically begin collecting battery data
    /// and sending it via OpenTelemetry’s metrics pipeline.
    public func startMonitoring() throws(BatterySDKError) {
        guard let meter else { throw .monitoringError(message: "Could not find stable meter provider, have you run the configure(_) method before ?") }
        
        // Start measure observations
        let gaugeBuilder = meter.gaugeBuilder(name: .gaugeName)
        doubleGaugeObservable = gaugeBuilder.buildWithCallback { [weak self] observableDoubleMeasurement in
            // Check the battery info synchronously
            let semaphore = DispatchSemaphore(value: 0)
            var batteryInfo: (value: Double, name: String, state: String)?
            Task {
                let device = await UIDevice.current
                let batteryValue = await device.batteryLevel.toPercentValue
                let deviceName = await device.name
                let batteryState = await device.batteryState.description
                batteryInfo = (batteryValue, deviceName, batteryState)
                semaphore.signal()
            }
            semaphore.wait()
            
            // Record the info
            if let batteryInfo {
                print(batteryInfo)
                observableDoubleMeasurement.record(value: batteryInfo.value,
                                                   attributes: [.device: AttributeValue.string(batteryInfo.name),
                                                                .batteryState: AttributeValue.string(batteryInfo.state)])
            }
        }
    }
}

// MARK: - Private extension
public extension String {
    static let meterName = "battery-monitoring"
    static let gaugeName = "batteryLevel"
}

// MARK: - Public extension
public extension BatteryManager {
    struct Configuration {
        let host: String
        let port: Port
        
        public init(host: String, port: Port) {
            self.host = host
            self.port = port
        }
    }
}
