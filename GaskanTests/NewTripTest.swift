//
//  NewTripTest.swift
//  GaskanTests
//
//  Created by Dzulfikar on 21/08/23.
//
// swiftlint:disable all

import XCTest
@testable import Gaskan
import CoreData

final class NewTripTest: XCTestCase {
    var newTripVM: NewTripViewModel = .init()
    var viewContext: NSManagedObjectContext = PersistenceController.test.container.viewContext
    var items: [Item] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        items = DatabaseSeed.seedItemData(viewContext: viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseSeed.deleteAllData(viewContext: viewContext)
    }

    /**
     Scenario test add item
     Given total mileage 155, fuel efficiency 15.5, fuel in 10, fuel cost per unit 10000, unit "Metric". 2 items in database
     When addItem is called
     Then 3 items in database, new item must be equal to total mileage, fuel efficiency, fuel in, fuel cost per unit, unit, and calculation type is trip
     */
    func testAddItem() throws {
        newTripVM.addItem(viewContext: viewContext, totalMileage: 155, fuelEfficiency: 15.5, unit: UnitDropdownOption(key: 1, value: "Metric"))
        
        let items = try viewContext.fetch(Item.fetchRequest())
        
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items.last?.type, CalculationType.newTrip.rawValue)
        XCTAssertEqual(items.last?.totalMileage, 155)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
