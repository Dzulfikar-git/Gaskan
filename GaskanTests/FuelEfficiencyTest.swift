//
//  FuelEfficiencyTest.swift
//  GaskanTests
//
//  Created by Dzulfikar on 21/08/23.
//
// swiftlint:disable all

import XCTest
import CoreData
@testable import Gaskan

final class FuelEfficiencyTest: XCTestCase {
    var fuelEfficiencyVm: FuelEfficiencyViewModel = .init()
    var viewContext: NSManagedObjectContext = PersistenceController.test.container.viewContext
    override func setUpWithError() throws {
        fuelEfficiencyVm.odometerStartForm = "100"
        fuelEfficiencyVm.odometerEndForm = "200"
        fuelEfficiencyVm.distanceForm = "100"
        fuelEfficiencyVm.fuelConsumedForm = "15.5"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseSeed.deleteAllData(viewContext: viewContext)
    }

    /**
     Scenario test calculate fuel efficiency by odometer
     Given: odometer start 100, odometer end 200, fuel consumed 15.5
     When: calculate fuel efficiency by odometer (odometer end - odometer start) / fuel consumed
     Then: fuel efficiency should be 6,451612903225806, (only 2 decimal) 6,45
     */
    func testcalculateFuelEfficiencyByOdometer() throws {
        fuelEfficiencyVm.odometerStartForm = "100"
        fuelEfficiencyVm.odometerEndForm = "200"
        fuelEfficiencyVm.fuelConsumedForm = "15.5"
        
        let fuelEfficiency = fuelEfficiencyVm.calculateFuelEfficiencyByOdometer()
        
        XCTAssertEqual(fuelEfficiency, String(6.45))
    }
    
    /**
    Scenario test calculate fuel efficiency by distance
    Given: distance 100, fuel consumed 15.5
    When: calculate fuel efficiency by distance distance / fuel consumed
    Then: fuel efficiency should be 6,451612903225806, (only 2 decimal) 6,45
     */
    func testCalculateFuelEfficiencyByDistance() throws {
        fuelEfficiencyVm.distanceForm = "100"
        fuelEfficiencyVm.fuelConsumedForm = "15.5"
        
        let fuelEfficiency = fuelEfficiencyVm.calculateFuelEfficiencyByDistance()
        
        XCTAssertEqual(fuelEfficiency, String(6.45))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
