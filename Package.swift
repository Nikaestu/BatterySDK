//
//  Package.swift
//  BatterySDK
//
//  Created by Dylan Le Hir on 3/6/25.
//

// swift-tools-version:6.0.3
import PackageDescription

let package = Package(
    name: "BatterySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "BatterySDK", targets: ["BatterySDK"]),
    ],
    targets: [
        .target(name: "BatterySDK", path: "BatterySDK")
    ]
)
