//
//  Float+utils.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

public extension Float {
    var toPercentValue: Double {
        return Double(self * 100)
    }
}
