//
//  BatterySDKLogger.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

import OSLog

class Logger {
    enum Level: String {
        case debug, info, warning, error
        
        var emojiValue: String {
            return switch self {
            case .debug: "🐛"
            case .info: "ℹ️"
            case .warning: "⚠️"
            case .error: "❌"
            }
        }
    }
    
    static func log(_ level: Level, message: String) {
        let formattedMessage = "[BatterySDK] [\(level.rawValue.uppercased())] \(level.emojiValue): \(message)"
        
        switch level {
        case .debug:
            #if DEBUG
            NSLog(formattedMessage)
            #endif
        default:
            NSLog(formattedMessage)
        }
    }
    
    static func debug(_ message: String) {
        log(.debug, message: message)
    }
    
    static func info(_ message: String) {
        log(.info, message: message)
    }
    
    static func warning(_ message: String) {
        log(.warning, message: message)
    }
    
    static func error(_ message: String) {
        log(.error, message: message)
    }
}
