//
//  DashboardViewModel.swift
//  Gaskan
//
//  Created by Dzulfikar on 18/08/23.
//

import Foundation
import CoreData
import SwiftUI

class DashboardViewModel: ObservableObject {
    static let shared: DashboardViewModel = .init()
    
    @Published var remainingMileage: Double = 0
    @Published var mileageDate: Date?
    @Published var unit: UnitDropdownOption? = UnitData.metricOption
    @Published var fuelEfficiency: Double = 0
    @Published var totalCosts: Int = 0
    @Published var prevMileage: Double = 0
    
    func getCalculationType(type: String) -> CalculationType {
        switch type {
        case CalculationType.newTrip.rawValue:
            return .newTrip
        case CalculationType.refuel.rawValue:
            return .refuel
        case CalculationType.newCalculation.rawValue:
            return .newCalculation
        default:
            return .newCalculation
        }
    }
    
    func getMileageAmount(totalMileage: Double, calculationType: CalculationType?) -> Double {
        var mileageAmount: Double
        switch calculationType {
            
        case .refuel:
            mileageAmount = totalMileage - prevMileage
            
            return mileageAmount
            
        case .newTrip:
            mileageAmount = prevMileage - totalMileage
            
            return mileageAmount
        case .newCalculation:
            mileageAmount = totalMileage
            
            return mileageAmount
        default:
            return 0
        }
    }
    
    func formatDateToString(date: Date?) -> String {
        if (date == nil) {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date!) {
            dateFormatter.dateFormat = "'Today', HH:mm"
        } else if calendar.isDateInYesterday(date!) {
            dateFormatter.dateFormat = "'Yesterday', HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM, HH:mm"
        }
        
        let dateString = dateFormatter.string(from: date!)
        
        return dateString
    }
    
    func updateRemainingMileage(items: FetchedResults<Item>) {
        // Update the UI asynchronously
        DispatchQueue.main.async {
            withAnimation {
                if let lastItem = items.last {
                    self.remainingMileage = Double(lastItem.totalMileage)
                    
                    self.mileageDate = lastItem.timestamp
                    self.fuelEfficiency = Double(lastItem.fuelEfficiency)
                    self.totalCosts = Int(lastItem.totalFuelCost)
                    self.unit = self.getUnit(unit: String(lastItem.unit ?? ""))
                    
                    // Loop through the remaining items in the array and adjust the remainingMileage value based on their calculationType
                    for index in (0..<items.count).reversed() {
                        let item = items[index]
                        let calculationType = self.getCalculationType(type: String(item.type ?? ""))
                        
                        let mileageAmount = Double(item.totalMileage)
                        
                        let fuelEff = Double(item.fuelEfficiency)
                        
                        let totalFuelCost = Int(item.totalFuelCost)
                        
                        switch calculationType {
                        case .refuel:
                            self.remainingMileage += mileageAmount
                            self.fuelEfficiency = fuelEff
                            self.totalCosts += totalFuelCost
                        case .newTrip:
                            self.remainingMileage -= mileageAmount
                            self.totalCosts -= totalFuelCost
                        default:
                            break
                        }
                    }
                } else {
                    self.remainingMileage = 0
                    self.mileageDate = nil
                    self.fuelEfficiency = 0
                    self.totalCosts = 0
                }
            }
        }
    }
    
    func getUnit(unit: String) -> UnitDropdownOption? {
        switch unit {
        case UnitData.metricOption.value:
            return UnitData.metricOption
        case UnitData.usOption.value:
            return UnitData.usOption
        default:
            return nil
        }
    }
    
    func deleteAllItems(viewContext: NSManagedObjectContext, items: [Item]) {
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
}
