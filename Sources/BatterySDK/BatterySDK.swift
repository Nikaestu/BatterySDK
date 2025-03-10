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

@MainActor
public class BatteryManager {
    
    public static let shared = BatteryManager()

    private let meterProvider: StableMeterProviderSdk
    private let meter: Meter
    private let batteryLevelMetric: ObservableDoubleGauge

    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        configure()

    }

    func configure() {
        
      Client
        
      let configuration = ClientConnection.Configuration.default(target: .hostAndPort("localhost", 4317),
                                                                 eventLoopGroup: MultiThreadedEventLoopGroup(numberOfThreads: 1))
      let client = ClientConnection(configuration: configuration)

      let resource = Resource(attributes: ["service.name": "StableMetricExample"]).merge(other: resource())

      OpenTelemetry.registerMeterProvider(meterProvider: StableMeterProviderSdk.builder().
        registerMetricReader(reader: StablePeriodicMetricReaderBuilder(exporter: StableOtlpMetricExporter(channel: client))
          .setInterval(timeInterval: 60).build()).build())
    }
}
