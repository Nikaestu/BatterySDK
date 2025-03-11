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
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let exporterChannel = ClientConnection.insecure(group: group)
            .connect(host: host, port: port)

        print("avant")
        let meterProvider = StableMeterProviderBuilder()
            .registerView(
                selector: InstrumentSelector.builder().setInstrument(name: ".*").build(),
                view: StableView.builder().build()
            )
            .registerMetricReader(
                reader: StablePeriodicMetricReaderBuilder(exporter: StableOtlpMetricExporter(channel: exporterChannel)).build()
            )
            .build()

        OpenTelemetry.registerStableMeterProvider(meterProvider: meterProvider)

        let meter = meterProvider.meterBuilder(name: "battery-monitor").build()
        print("après")
        
        // Activer la surveillance de la batterie
        UIDevice.current.isBatteryMonitoringEnabled = true

        // Créer une métrique observable pour le niveau de batterie
        _ = meter.gaugeBuilder(name: "device.battery_level")
            .buildWithCallback { observer in
                let batteryLevel = UIDevice.current.batteryLevel * 100
                print("Battery Level Callback Executed: \(batteryLevel)") // ✅ Vérification
                if batteryLevel >= 0 {
                    print("avant le record")
                    observer.record(value: Double(batteryLevel))
                    print("après le record")
                } else {
                    print("❌ Valeur de batteryLevel invalide : \(batteryLevel)")
                }
            }
        
        print("Toutes les étapes de la configuration sont terminées ! 🎉🚴")
    }
}
