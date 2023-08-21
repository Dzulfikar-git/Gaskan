//
//  RefuelTest.swift
//  GaskanTests
//
//  Created by Dzulfikar on 21/08/23.
//
// swiftlint:disable all

import XCTest
@testable import Gaskan
import CoreData

final class RefuelTest: XCTestCase {
    var refuelViewModel: RefuelViewModel = .init()
    var viewContext: NSManagedObjectContext = PersistenceController.test.container.viewContext
    var items: [Item] = []
    
    override func setUpWithError() throws {
        items = DatabaseSeed.seedItemData(viewContext: viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // delete all data
        DatabaseSeed.deleteAllData(viewContext: viewContext)
    }

    /**
     Scenario Test calculate total mileage
     Given fuelEfficiency 15.5, fuelIn 10
     When calculateTotalMileage is called
     Then totalMileage is 155
     */
    func testCalculateTotalMileage() throws {
        refuelViewModel.fuelEfficiencyForm = String(15.5)
        refuelViewModel.fuelInForm = String(10)
        refuelViewModel.calculateTotalMileage()
        
        XCTAssertEqual(refuelViewModel.totalMileage, 155)
    }
    
    /**
     Scenario test add item
     Given totalMileage 155, fuelEfficiency 15.5, fuelInForm 10, fuelCostPerUnit 10000, unit "Metric". 2 items in database
     When addItem is called
     Then 3 items in database, new item must be equal to totalMileage, fuelEfficiency, fuelInForm, fuelCostPerUnit, unit, and calculation type is refuel
     */
    func testAddItem() throws {
        refuelViewModel.addItem(viewContext: viewContext, totalMileage: 155, fuelEfficiency: 15.5, fuelInForm: 10, fuelCostPerUnit: 10000, unit: UnitDropdownOption(key: 1, value: "Metric"))
        
        let items = try viewContext.fetch(Item.fetchRequest())
        
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items.last?.type, CalculationType.refuel.rawValue)
        XCTAssertEqual(items.last?.totalMileage, 155)
        XCTAssertEqual(items.last?.fuelEfficiency, 15.5)
        XCTAssertEqual(items.last?.totalFuelCost, (10 * 10000))
        XCTAssertEqual(items.last?.unit, "Metric")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
