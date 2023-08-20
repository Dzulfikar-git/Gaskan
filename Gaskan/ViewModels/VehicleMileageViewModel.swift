//
//  VehicleMileageViewModel.swift
//  Gaskan
//
//  Created by Dzulfikar on 18/08/23.
//

import Foundation
import SwiftUI

class VehicleMileageViewModel: ObservableObject {
    static let shared: VehicleMileageViewModel = .init()
    
    @Published var shouldShowDropdown: Bool = false
    @Published var isDropdownExpanding: Bool = false
    
    @Published var selectedOption: UnitDropdownOption? = UnitData.metricOption
    
    @Published var fuelEfficiencyForm: String = ""
    @Published var isFuelEfficiencyFormErrorInput: Bool = false
    @Published var fuelEfficiencyFormErrorMessage: String = ""
    
    @Published var fuelInForm: String = ""
    @Published var isFuelInFormErrorInput: Bool = false
    @Published var fuelInFormErrorMessage: String = ""
    
    @Published var fuelCostPerUnitForm: String = ""
    
    @Published var isFindingFuelEfficiency: Bool = false
    
    @Published var isCalculateButtonPressed: Bool = false
    
    @Published var totalMileage: Double = 0
    
    func calculateTotalMileage() {
        totalMileage = ((Double(fuelEfficiencyForm) ?? 0) * (Double(fuelInForm) ?? 0)).rounded(.toNearestOrAwayFromZero)
    }
    
    func validateForm() {
        if fuelEfficiencyForm.isEmpty {
            isFuelEfficiencyFormErrorInput = true
            fuelEfficiencyFormErrorMessage = "Fuel efficiency cannot be empty"
        } else {
            isFuelEfficiencyFormErrorInput = false
            fuelEfficiencyFormErrorMessage = ""
        }
        
        if fuelInForm.isEmpty {
            isFuelInFormErrorInput = true
            fuelInFormErrorMessage = "Fuel in cannot be empty"
        } else {
            isFuelInFormErrorInput = false
            fuelInFormErrorMessage = ""
        }
    }
    
    func resetValidation() {
        isFuelEfficiencyFormErrorInput = false
        isFuelInFormErrorInput = false
    }
    
    func resetFormData() {
        self.fuelEfficiencyForm = ""
        self.fuelInForm = ""
        self.fuelCostPerUnitForm = ""
    }
}
