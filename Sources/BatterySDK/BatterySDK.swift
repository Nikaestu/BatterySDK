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
//    private var timer: Timer?
//
    public init() {
        print("Init de BatteryManager")
        UIDevice.current.isBatteryMonitoringEnabled = true
        print("Battery monitoring enabled")
    }
//
//    public func startMonitoring() {
//        print("🔄 Démarrage du monitoring de la batterie")
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
//            Task { @MainActor in
//                self?.sendBatteryLevel()
//            }
//        }
//        sendBatteryLevel() // Envoi immédiat de la première mesure
//    }
//
//    private func sendBatteryLevel() {
//        let batteryLevel = UIDevice.current.batteryLevel * 100 // Conversion en pourcentage
//        print("📡 Envoi métrique: BatteryLevel -> \(batteryLevel)%")
//
//        let url = URL(string: "http://192.168.1.227:4318/v1/metrics")!
//        let json: [String: Any] = [
//            "resourceMetrics": [
//                [
//                    "resource": [
//                        "attributes": [
//                            ["key": "service.name", "value": ["stringValue": "battery-collector-service"]],
//                            ["key": "device.name", "value": ["stringValue": UIDevice.current.name]],
//                            ["key": "battery.state", "value": ["stringValue": UIDevice.current.batteryState.description]]
//                        ]
//                    ],
//                    "scopeMetrics": [
//                        [
//                            "scope": ["name": "battery-level"],
//                            "metrics": [
//                                [
//                                    "name": "batteryLevel",
//                                    "description": "Niveau de batterie de l'iPhone",
//                                    "gauge": [
//                                        "dataPoints": [
//                                            [
//                                                "value": ["asDouble": batteryLevel],
//                                                "timeUnixNano": "\(UInt64(Date().timeIntervalSince1970 * 1_000_000_000))",
//                                                "attributes": [
//                                                    ["key": "device", "value": ["stringValue": UIDevice.current.name]],
//                                                    ["key": "battery_state", "value": ["stringValue": UIDevice.current.batteryState.description]]
//                                                ]
//                                            ]
//                                        ],
//                                        "aggregationTemporality": 2
//                                    ]
//                                ]
//                            ]
//                        ]
//                    ]
//                ]
//            ]
//        ]
//
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
//            print("❌ Erreur lors de la conversion du JSON")
//            return
//        }
//
//        // Affichage du JSON pour debug
//        if let jsonString = String(data: jsonData, encoding: .utf8) {
//            print("📤 JSON envoyé :", jsonString)
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Erreur lors de l'envoi des métriques :", error)
//                return
//            }
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📤 Statut de la réponse :", httpResponse.statusCode)
//                if let data = data {
//                    print("📥 Réponse :", String(data: data, encoding: .utf8) ?? "Aucune réponse")
//                }
//            }
//        }
//        task.resume()
//    }
//}
//
//private extension UIDevice.BatteryState {
//    var description: String {
//        switch self {
//        case .unknown: return "unknown"
//        case .unplugged: return "unplugged"
//        case .charging: return "charging"
//        case .full: return "full"
//        @unknown default: return "unknown"
//        }
//    }
    
    public func basicConfiguration() {
      let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        // 4317: gRPC et 4318: http
      let exporterChannel = ClientConnection.insecure(group: group)
        .connect(host: "192.168.1.110", port: 4317)

        // Gauge - Counter - etc...
      OpenTelemetry.registerStableMeterProvider(meterProvider: StableMeterProviderBuilder()
        .registerView(selector: InstrumentSelector.builder().setInstrument(name: ".*").build(), view: StableView.builder().build())
        .registerMetricReader(reader: StablePeriodicMetricReaderBuilder(exporter: StableOtlpMetricExporter(channel: exporterChannel)).build())
        .build()
      )
    }
    
}

