//
//  VehicleMileageResultViewModel.swift
//  Gaskan
//
//  Created by Dzulfikar on 19/08/23.
//

import Foundation
import CoreData
import SwiftUI

class VehicleMileageResultViewModel: ObservableObject {
    static let shared: VehicleMileageViewModel = .init()
    
    func addItem(viewContext: NSManagedObjectContext, calculationType: String, totalMileage: Float, fuelEfficiency: Float, fuelIn: Float, fuelCostPerUnit: Float, unit: UnitDropdownOption) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.type = calculationType
            newItem.timestamp = Date()
            newItem.totalMileage = totalMileage
            newItem.fuelEfficiency = fuelEfficiency
            newItem.totalFuelCost = fuelIn * fuelCostPerUnit
            newItem.unit = unit.value
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteAllItems(viewContext: NSManagedObjectContext, items: FetchedResults<Item>) {
        for item in items {
            deleteItem(viewContext: viewContext, item: item)
        }
    }
    
    func deleteItem(viewContext: NSManagedObjectContext, item: Item) {
        withAnimation {
            viewContext.delete(item)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveAppDefaultHasCalculation() {
        UserDefaults.standard.set(true, forKey: "isCalculated")
    }
}
