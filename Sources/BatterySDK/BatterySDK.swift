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
            // Indique quel type de données est utilisé (Gauge, countrer, etc...)
            // On documente la métrique avec un titre, une description et une version
            // Ca facilitera la lecture vers Prometheus ou Grafana
            .registerView(
                selector: InstrumentSelector.builder().setInstrument(name: "Gauge").setMeter(version: "1").build(),
                view: StableView.builder().withName(name: "Niveau de batterie de l'iPhone").withDescription(description: "On récupère le niveau de la batterie afin de suivre son évolution").build()
            )
            // Crée un lecteur périodique qui récupère et envoie les métriques
            // Configuration du OTLP qui envoie ici les données vers otel-collector via gRPC
            .registerMetricReader(
                reader: StablePeriodicMetricReaderBuilder(exporter: StableOtlpMetricExporter(channel: exporterChannel)).build()
            )
            .build()

        // Enregistre le meter
        OpenTelemetry.registerStableMeterProvider(meterProvider: meterProvider)
        
        // On utilise le meterProvider pour crée un meter
        let meter = meterProvider.meterBuilder(name: "MeterBatteryMonitoring").build()

        // On crée une gauge ou "jauge" en fr
        var gaugeBuilder = meter.gaugeBuilder(name: "BatteryLevelGauge")
        
        // On observe la gauge
        var observableGauge = gaugeBuilder.buildWithCallback { ObservableDoubleMeasurement in
            print("Début de la méthode observableGauge")
            ObservableDoubleMeasurement.record(value: 1.0, attributes: ["test": AttributeValue.bool(true)])
            print("Fin de la méthode observableGauge")
        }
        
        print("Toutes les étapes de la configuration sont terminées ! 🎉🚴")
    }
}
