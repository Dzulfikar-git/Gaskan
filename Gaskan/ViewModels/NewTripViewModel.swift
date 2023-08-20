//
//  NewTripViewModel.swift
//  Gaskan
//
//  Created by Dzulfikar on 20/08/23.
//

import Foundation
import CoreData
import SwiftUI

class NewTripViewModel: ObservableObject {
    @Published var fuelEfficiencyValue: String = "0.0"
    
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
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertDescription = ""
    
    func validateForm() {
        if selectedDistanceView == 0 {
            if distanceForm.isEmpty {
                isDistanceFormErrorInput = true
                distanceFormErrorMessage = "Distance cannot be empty"
            } else {
                isDistanceFormErrorInput = false
                distanceFormErrorMessage = ""
            }
        } else {
            if odometerStartForm.isEmpty {
                isOdometerStartFormErrorInput = true
                odometerStartFormErrorMessage = "Odometer start cannot be empty"
            } else {
                isOdometerStartFormErrorInput = false
                odometerStartFormErrorMessage = ""
            }
            
            if odometerEndForm.isEmpty {
                isOdometerEndFormErrorInput = true
                odometerEndFormErrorMessage = "Odometer end cannot be empty"
            } else {
                isOdometerEndFormErrorInput = false
                odometerEndFormErrorMessage = ""
            }
        }
    }
    
    func resetValidation() {
        isDistanceFormErrorInput = false
        isOdometerStartFormErrorInput = false
        isOdometerEndFormErrorInput = false
    }
    
    func resetForm() {
        distanceForm = ""
        odometerStartForm = ""
        odometerEndForm = ""
    }
    
    func addItem(viewContext: NSManagedObjectContext, totalMileage: Float, fuelEfficiency: Float, unit: UnitDropdownOption) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.type = CalculationType.newTrip.rawValue
            newItem.timestamp = Date()
            newItem.totalMileage = totalMileage
            newItem.fuelEfficiency = fuelEfficiency
            newItem.totalFuelCost = 0.0
            newItem.unit = unit.value
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
