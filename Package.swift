//
//  Package.swift
//  BatterySDK
//
//  Created by Dylan Le Hir on 3/6/25.
//

// swift-tools-version:6.0.0
import PackageDescription

let package = Package(
    name: "BatterySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "BatterySDK", targets: ["BatterySDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/open-telemetry/opentelemetry-swift.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BatterySDK",
            dependencies: [
                .product(name: "OpenTelemetryApi", package: "opentelemetry-swift"),
                .product(name: "OpenTelemetrySdk", package: "opentelemetry-swift"),
                .product(name: "OpenTelemetryProtocolExporter", package: "opentelemetry-swift")
            ],
            path: "Sources"
        ),
    ]
)
