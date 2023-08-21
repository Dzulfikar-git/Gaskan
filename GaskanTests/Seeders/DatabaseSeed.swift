//
//  DatabaseSeed.swift
//  GaskanTests
//
//  Created by Dzulfikar on 21/08/23.
//

import Foundation
import CoreData
@testable import Gaskan

class DatabaseSeed {
    static func seedItemData(viewContext: NSManagedObjectContext) -> [Item] {
        let newItem = Item(context: viewContext)
        newItem.id = UUID()
        newItem.fuelEfficiency = 10.0
        newItem.totalFuelCost = 10000
        newItem.totalMileage = 15.0
        newItem.type = CalculationType.newCalculation.rawValue
        newItem.unit = UnitData.metricOption.value
        newItem.timestamp = Date()
        
        let newItem2 = Item(context: viewContext)
        newItem2.id = UUID()
        newItem2.fuelEfficiency = 10.0
        newItem2.totalFuelCost = 10000
        newItem2.totalMileage = 15.0
        newItem2.type = CalculationType.newCalculation.rawValue
        newItem2.unit = UnitData.metricOption.value
        newItem2.timestamp = Date()
       
        do {
            try viewContext.save()
            return try viewContext.fetch(Item.fetchRequest())
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func deleteAllData(viewContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
