//
//  DoubleMeasurementObservable.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

import OpenTelemetryApi

public extension ObservableDoubleMeasurement {
    func record(value: Double, attributes: [ObservableDoubleMeasurementAttribute : AttributeValue]) {
        record(value: value,
               attributes: attributes.reduce(into: [:], { $0[$1.key.rawValue] = $1.value }))
    }
}

public enum ObservableDoubleMeasurementAttribute: String {
    case device
    case batteryState = "battery_state"
}
