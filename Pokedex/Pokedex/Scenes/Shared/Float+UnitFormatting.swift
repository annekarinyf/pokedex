//
//  Float+UnitFormatting.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import Foundation

extension Float {
    func toMetersFormatted() -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        let measure = Measurement(value: Double(Int(self)), unit: UnitLength.meters)
        return formatter.string(from: measure)
    }
    
    func toKilogramsFormatted() -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        let measure = Measurement(value: Double(Int(self)), unit: UnitMass.kilograms)
        return formatter.string(from: measure)
    }
}
