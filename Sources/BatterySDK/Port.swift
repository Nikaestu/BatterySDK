//
//  Port.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

public enum Port {
    case http
    case gRPC
    case custom(value: Int)
    
    var value: Int {
        return switch self {
        case .gRPC: 4317
        case .http: 4318
        case .custom(let value): value
        }
    }
}
