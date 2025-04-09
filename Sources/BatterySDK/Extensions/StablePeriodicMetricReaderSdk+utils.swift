//
//  File.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

import OpenTelemetrySdk
import OpenTelemetryApi
import OpenTelemetryProtocolExporterGrpc
import GRPC

extension StablePeriodicMetricReaderSdk {
    static func `default`(channel: ClientConnection) -> StablePeriodicMetricReaderSdk {
        return StablePeriodicMetricReaderBuilder(exporter: StableOtlpMetricExporter(channel: channel)).build()
    }
}
