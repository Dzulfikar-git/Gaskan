//
//  UnitData.swift
//  Gaskan
//
//  Created by Dzulfikar on 06/04/23.
//

import Foundation
struct UnitData {
    static let metricOption = UnitDropdownOption(key: 0, value: "Metric")
    static let usOption = UnitDropdownOption(key: 1, value: "US")
    
    static let unitOptions: [UnitDropdownOption] = [
        metricOption, usOption
    ]
}

