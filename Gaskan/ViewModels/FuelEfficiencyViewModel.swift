//
//  FuelEfficiencyViewModel.swift
//  Gaskan
//
//  Created by Dzulfikar on 19/08/23.
//

import Foundation
class FuelEfficiencyViewModel: ObservableObject {
    static let shared: FuelEfficiencyViewModel = .init()
    
    @Published var shouldShowDropdown: Bool = false
    @Published var isDropdownExpanding: Bool = false
    
    @Published var selectedDistanceView: Int = 0
    
    @Published var distanceForm: String = ""
    @Published var isDistanceFormErrorInput: Bool = false
    @Published var distanceFormErrorMessage: String = ""
    
    @Published var odometerStartForm: String = ""
    @Published var isOdometerStartFormErrorInput: Bool = false
    @Published var odometerStartFormErrorMessage: String = ""
    
    @Published var odometerEndForm: String = ""
    @Published var isOdometerEndFormErrorInput: Bool = false
    @Published var odometerEndFormErrorMessage: String = ""
    
    @Published var fuelConsumedForm: String = ""
    @Published var isFuelConsumedFormErrorInput: Bool = false
    @Published var fuelConsumedFormErrorMessage: String = ""
    
    func calculateFuelEfficiencyByOdometer() -> String {
        let fuelEfficiency = (((Double(self.odometerEndForm) ?? 0) - (Double(self.odometerStartForm) ?? 0))) / (Double(self.fuelConsumedForm) ?? 0)
        return String(format: "%.2f", fuelEfficiency)
    }
    
    func calculateFuelEfficiencyByDistance() -> String {
        let fuelEfficiency = ((Double(self.distanceForm) ?? 0) / (Double(self.fuelConsumedForm) ?? 0))
        return String(format: "%.2f", fuelEfficiency)
    }
    
    func validateForm() {
        if self.selectedDistanceView == 0 {
            if self.distanceForm.isEmpty {
                self.isDistanceFormErrorInput = true
                self.distanceFormErrorMessage = "Distance cannot be empty"
            } else {
                self.isDistanceFormErrorInput = false
                self.distanceFormErrorMessage = ""
            }
            
            if self.fuelConsumedForm.isEmpty {
                self.isFuelConsumedFormErrorInput = true
                self.fuelConsumedFormErrorMessage = "Fuel consume cannot be empty"
            } else {
                self.isFuelConsumedFormErrorInput = false
                self.fuelConsumedFormErrorMessage = ""
            }
        } else {
            if self.odometerStartForm.isEmpty {
                self.isOdometerStartFormErrorInput = true
                self.odometerStartFormErrorMessage = "Odometer start cannot be empty"
            } else {
                self.isOdometerStartFormErrorInput = false
                self.odometerStartFormErrorMessage = ""
            }
            
            if self.odometerEndForm.isEmpty {
                self.isOdometerEndFormErrorInput = true
                self.odometerEndFormErrorMessage = "Odometer end cannot be empty"
            } else {
                self.isOdometerEndFormErrorInput = false
                self.odometerEndFormErrorMessage = ""
            }
        }
    }
    
    func resetValidation() {
        self.isDistanceFormErrorInput = false
        self.isOdometerStartFormErrorInput = false
        self.isOdometerEndFormErrorInput = false
        self.isFuelConsumedFormErrorInput = false
    }
    
    func resetFormData() {
        self.distanceForm = ""
        self.odometerStartForm = ""
        self.odometerEndForm = ""
        self.fuelConsumedForm = ""
    }
}
