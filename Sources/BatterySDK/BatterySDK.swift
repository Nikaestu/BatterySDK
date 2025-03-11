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
    
    public init() {}
        
    public func basicConfiguration(host: String, port: Int) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let exporterChannel = ClientConnection.insecure(group: group)
            .connect(host: host, port: port)
        let meterProvider = StableMeterProviderBuilder()
            .registerView(
                selector: InstrumentSelector.builder().setInstrument(name: "Gauge").build(),
                view: StableView.builder().build()
            )
            .registerMetricReader(
                reader: StablePeriodicMetricReaderBuilder(exporter: StableOtlpMetricExporter(channel: exporterChannel)).build()
            )
            .build()

        OpenTelemetry.registerStableMeterProvider(meterProvider: meterProvider)

        // creating a new meter & instrument
        let meter = meterProvider.meterBuilder(name: "battery-monitor").build()

        var gaugeBuilder = meter.gaugeBuilder(name: "Gauge")

        // observable gauge
        var observableGauge = gaugeBuilder.buildWithCallback { ObservableDoubleMeasurement in
          ObservableDoubleMeasurement.record(value: 1.0, attributes: ["test": AttributeValue.bool(true)])
        }
        
        print("Toutes les étapes de la configuration sont terminées ! 🎉🚴")
    }
}
