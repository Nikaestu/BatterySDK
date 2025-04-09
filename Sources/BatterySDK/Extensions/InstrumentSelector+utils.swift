//
//  File.swift
//  BatterySDK
//
//  Created by Alexandre Faltot on 09/04/2025.
//

import OpenTelemetrySdk

extension InstrumentSelector {
    static var `default`: InstrumentSelector {
        return InstrumentSelector.builder().setInstrument(name: ".*").build()
    }
}
