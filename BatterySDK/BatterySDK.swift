//
//  BatterySDK.swift
//  BatterySDK
//
//  Created by Dylan Le Hir on 3/6/25.
//

import UIKit

public class BatteryManager {
    
    public static let shared = BatteryManager()
    
    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    public func getBatteryLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
}
