//
//  RefuelViewModel.swift
//  Gaskan
//
//  Created by Dzulfikar on 19/08/23.
//

import Foundation
import CoreData
import SwiftUI
class RefuelViewModel: ObservableObject {
    
    @Published var shouldShowDropdown = false
    @Published var isDropdownExpanding = false
    
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
        if let fuelEfficiency = Float(fuelEfficiencyForm),
            let fuelIn = Float(fuelInForm) {
            totalMileage = Double(fuelEfficiency * fuelIn)
        }
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
        fuelEfficiencyForm = ""
        fuelInForm = ""
    }
    
    func addItem(viewContext: NSManagedObjectContext, totalMileage: Float, fuelEfficiency: Float, fuelInForm: Float, fuelCostPerUnit: Float, unit: UnitDropdownOption) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.type = CalculationType.refuel.rawValue
            newItem.timestamp = Date()
            newItem.totalMileage = totalMileage
            newItem.fuelEfficiency = fuelEfficiency
            newItem.totalFuelCost = fuelInForm * fuelCostPerUnit
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
