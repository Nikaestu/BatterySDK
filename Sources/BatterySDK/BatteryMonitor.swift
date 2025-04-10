//
//  SC.swift
//  BatterySDK
//
//  Created by Dylan Le Hir on 4/10/25.
//
import UIKit
import OpenTelemetryApi

public final class BatteryMonitor {
    
    @MainActor public static let instance = BatteryMonitor()
    private var doubleGaugeObservable: ObservableDoubleGauge?

    init() {}

//
//    // MARK: - Public methods
//    
//    /// Starts monitoring the device's battery level and records it as a gauge metric.
//    ///
//    /// This method creates a gauge metric to track the device's battery level. It uses
//    /// OpenTelemetry's meter builder to construct a gauge that periodically records the
//    /// current battery level as an observable value. The battery state and device name
//    /// are also included as attributes for the recorded measurement. The battery level
//    /// is printed to the console as a percentage.
//    ///
//    /// - Note: This method uses `UIDevice.current` to retrieve the device's current battery
//    ///   level and state. The battery level is recorded as a percentage value.
    public func startMonitoring(opentelemetry: OpenTelemetry) throws(BatterySDKError) {
        // Create meter
        let meter = opentelemetry
            .stableMeterProvider?
            .meterBuilder(name: .meterName)
            .build()
        
        guard let meter else { throw .configurationMeter }
        
        let gaugeBuilder = meter.gaugeBuilder(name: .gaugeName)
        doubleGaugeObservable = gaugeBuilder.buildWithCallback { [weak self] observableDoubleMeasurement in
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
            if let batteryInfo {
                print(batteryInfo)
                observableDoubleMeasurement.record(value: batteryInfo.value,
                                                   attributes: [.device: AttributeValue.string(batteryInfo.name),
                                                                .batteryState: AttributeValue.string(batteryInfo.state)])
            }
        }
    }
}
