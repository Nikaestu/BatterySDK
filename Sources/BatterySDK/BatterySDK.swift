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

@MainActor
public class BatteryManager {
    // MARK: - Private properties
    private var meter: StableMeter?
    private var doubleGaugeObservable: ObservableDoubleGauge?
    private var batteryInfo: (value: Double, name: String, state: String)?

    // MARK: - Public properties
    
    /// The default instance of BatteryManager
    public static let instance = BatteryManager()
    
    // MARK: - Private methods
    
    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    /// Configures the OpenTelemetry SDK with the specified configuration.
    ///
    /// This method sets up a `MultiThreadedEventLoopGroup` with one thread and creates a
    /// `ClientConnection` to the specified host and port for exporting metrics. It then
    /// registers a `StableMeterProvider` with a default view and a default metric reader
    /// to export the metrics to the specified connection.
    ///
    /// - Parameter configuration: A `Configuration` object containing the host and port
    ///   for the exporter connection. The default value is `Configuration(host: "192.168.1.110", port: .gRPC)`.
    ///   - `host`: The host to which the metrics will be exported (default is `"192.168.1.110"`).
    ///   - `port`: The port to use for the connection (default is `.gRPC`).
    ///
    /// This method will register the meter provider with OpenTelemetry to handle the
    /// collection and export of metrics.
    public func configure(_ configuration: Configuration) throws(BatterySDKError) {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let exporterChannel = ClientConnection.insecure(group: group)
            .connect(host: configuration.host,
                     port: configuration.port.value)
        
        // Gauge - Counter - etc...
        let meterProvider = StableMeterProviderBuilder()
            .registerView(selector: InstrumentSelector.default,
                          view: StableView.default)
            .registerMetricReader(reader: StablePeriodicMetricReaderSdk.default(channel: exporterChannel))
            .build()
        
        OpenTelemetry.registerStableMeterProvider(meterProvider: meterProvider)
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

