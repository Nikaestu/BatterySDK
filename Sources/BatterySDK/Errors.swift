//
//  Errors.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

public enum BatterySDKError: Error {
    case configurationError(message: String)
    case monitoringError(message: String)
}
