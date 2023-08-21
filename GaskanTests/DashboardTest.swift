//
//  DashboardTest.swift
//  GaskanTests
//
//  Created by Dzulfikar on 20/08/23.
//
// swiftlint:disable all

import XCTest
@testable import Gaskan
import CoreData
import SwiftUI

final class DashboardTest: XCTestCase {
    var dashboardVM: DashboardViewModel = .init()
    var viewContext: NSManagedObjectContext = PersistenceController.test.container.viewContext
    var items: [Item] = []
   
    override func setUpWithError() throws {
        items = DatabaseSeed.seedItemData(viewContext: viewContext)
        dashboardVM.prevMileage = 500
        dashboardVM.fuelEfficiency = 10
        dashboardVM.totalCosts = 100000
        dashboardVM.remainingMileage = 0
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseSeed.deleteAllData(viewContext: viewContext)
    }

    /**
    Scenario  Test All Calculation Type
    Given all calculation type
    Then the calculation type should be correct
     */
    func testGetAllCalculationType() throws {
        XCTAssertEqual(dashboardVM.getCalculationType(type: CalculationType.newTrip.rawValue), .newTrip)
        XCTAssertEqual(dashboardVM.getCalculationType(type: CalculationType.refuel.rawValue), .refuel)
        XCTAssertEqual(dashboardVM.getCalculationType(type: CalculationType.newCalculation.rawValue), .newCalculation)
    }

    /**
     Scenario: Test get mileage amount with new trip type
     Given: Total mileage 100 and calculation type is new trip
     Then: It should return 400
     */
    func testGetMileageAmountNewTripType() throws {
        XCTAssertEqual(dashboardVM.getMileageAmount(totalMileage: 100, calculationType: .newTrip), 400)
    }

    /**
     Scenario: Test get mileage amount with refuel type
     Given: total mileage 100 and calculation type is refuel
     Then: It should return 400
     */
    func testGetMileageAmountRefuelType() throws {
        XCTAssertEqual(dashboardVM.getMileageAmount(totalMileage: 100, calculationType: .newTrip), 400)
    }

    /**
    Scenario: Test get mileage amount with new calculation type
    Given: total mileage 100 and calculation type is new calculation
    Then: It should return 100
     */
    func testGetMileageAmountNewCalculationType() throws {
        XCTAssertEqual(dashboardVM.getMileageAmount(totalMileage: 100, calculationType: .newCalculation), 100)
    }

    /**
    Scenario: Test format date to string
    Given: date is today
    Then: It should return Today, 00:00
     */
    func testFormatDateToString() throws {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)

        XCTAssertEqual(dashboardVM.formatDateToString(date: date), "Today, \(dateString)")
    }

    /**
     Scenario: Test get unit
     Given: Metric/US String
     Then: It should return option respectively
     */
    func testGetUnit() throws {
        XCTAssertEqual(dashboardVM.getUnit(unit: "Metric"), UnitData.metricOption)
        XCTAssertEqual(dashboardVM.getUnit(unit: "US"), UnitData.usOption)
    }

    /**
    Scenario: Test update remaining mileage
    Given: items with total mileage 15, then update remaining mileage
    Then: It should return 15 as remaining mileage
     */
    func testUpdateRemainingMileage() throws {
        let viewContext = PersistenceController.test.container.viewContext
        let itemFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let itemResults = try viewContext.fetch(itemFetch) as? [Item] ?? []
        dashboardVM.updateRemainingMileage(items: itemResults)
        XCTAssertEqual(dashboardVM.remainingMileage, 15)
    }
    /**
     Scenario: Test delete item
     Given: items with total count 2
     Then: It should return 1 as items count
     */
    func testDeleteItem() throws {
        dashboardVM.deleteItem(viewContext: viewContext, item: items[0])
        let itemsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let itemsResult = try viewContext.fetch(itemsRequest) as? [Item] ?? []
        XCTAssertEqual(itemsResult.count, 1)
    }
    /**
     Scenario: Test delete all items
     Given: items with total count 10
     Then: It should return 0 as items count
      */
    func testDeleteAllItems() throws {
        dashboardVM.deleteAllItems(viewContext: viewContext, items: items)
        let itemsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let itemsResult = try viewContext.fetch(itemsRequest) as? [Item] ?? []
        XCTAssertEqual(itemsResult.count, 0)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
