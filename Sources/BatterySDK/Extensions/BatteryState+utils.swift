//
//  BatteryState+utils.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//


import UIKit

public extension UIDevice.BatteryState {
    var description: String {
        switch self {
        case .unknown: return "unknown"
        case .unplugged: return "unplugged"
        case .charging: return "charging"
        case .full: return "full"
        @unknown default: return "unknown"
        }
    }
}
