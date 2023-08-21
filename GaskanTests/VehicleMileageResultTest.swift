//
//  VehicleMileageResultTest.swift
//  GaskanTests
//
//  Created by Dzulfikar on 21/08/23.
//
// swiftlint:disable all

import XCTest
@testable import Gaskan
import CoreData

final class VehicleMileageResultTest: XCTestCase {
    var vehicleMileageResultVm: VehicleMileageResultViewModel = .init()
    var viewContext: NSManagedObjectContext = PersistenceController.test.container.viewContext
    var items: [Item] = []
    
    override func setUpWithError() throws {
        items = DatabaseSeed.seedItemData(viewContext: viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseSeed.deleteAllData(viewContext: viewContext)
    }

    /**
     Scenario: add item to core data
     Given: newCalculation type, total mileage 160, fuel efficiency 16, fuel in 10, fuel cost per unit 10000, unit metric
     When add item
     Then: item should be added to core data, total item should be 13, the last item should have total fuel cost 100000, unit Metric, total mileage 160, fuel efficiency 16, fuel in 10
     */
    func testAddItem() throws {
        vehicleMileageResultVm.addItem(viewContext: viewContext, calculationType: CalculationType.newCalculation.rawValue, totalMileage: 160, fuelEfficiency: 16, fuelIn: 10, fuelCostPerUnit: 10000, unit: UnitDropdownOption.init(key: 1, value: "Metric"))
        
        let items = try viewContext.fetch(Item.fetchRequest())
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items.last?.totalFuelCost, 100000)
        XCTAssertEqual(items.last?.unit, "Metric")
        XCTAssertEqual(items.last?.totalMileage, 160)
        XCTAssertEqual(items.last?.fuelEfficiency, 16)
    }

    /**
     Scenario test delete item from core data
     Given 2 data from seed
     When delete first item
     Then total item should be 1
     */
    func testDeleteItem() throws {
        vehicleMileageResultVm.deleteItem(viewContext: viewContext, item: items.first!)
        
        let items = try viewContext.fetch(Item.fetchRequest())
        XCTAssertEqual(items.count, 1)
    }
    
    /**
     Scenario test delete all items from core data
     Given 2 data from seed
     When delete all items
     Then total item should be 0
     */
    func testDeleteAllItems() throws {
        vehicleMileageResultVm.deleteAllItems(viewContext: viewContext, items: items)
        
        let items = try viewContext.fetch(Item.fetchRequest())
        XCTAssertEqual(items.count, 0)
    }
    
    /**
     Scenario test save app default has calculation
     Given app default isCalculated is false
     When save app default has calculation
     Then isCalculated should be true
     */
    func testSaveAppDefaultHasCalculation() throws {
        vehicleMileageResultVm.saveAppDefaultHasCalculation()
        
        let isCalculated = UserDefaults.standard.bool(forKey: "isCalculated")
        XCTAssertTrue(isCalculated)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
