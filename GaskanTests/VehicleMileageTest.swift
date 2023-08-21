//
//  VehicleMileageTest.swift
//  GaskanTests
//
//  Created by Dzulfikar on 21/08/23.
//

import XCTest
import SwiftUI
import CoreData

@testable import Gaskan

final class VehicleMileageTest: XCTestCase {
    var vehicleMileageVm: VehicleMileageViewModel = .init()
    var viewContext: NSManagedObjectContext = PersistenceController.test.container.viewContext
    var items: [Item] = []
    override func setUpWithError() throws {
        items = DatabaseSeed.seedItemData(viewContext: viewContext)
        vehicleMileageVm.totalMileage = 100
        vehicleMileageVm.fuelEfficiencyForm = String(10)
        vehicleMileageVm.fuelInForm = String(10)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        DatabaseSeed.deleteAllData(viewContext: viewContext)
    }

    /**
     Scenario: Test calculate total mileage
     Given: Fuel Efficiency 16 and Fuel In 10
     Then: It should return 160 as total mileage (16 * 10)
     */
    func testCalculateTotalMileage() throws {
        vehicleMileageVm.fuelEfficiencyForm = String(16)
        vehicleMileageVm.fuelInForm = String(10)
        vehicleMileageVm.calculateTotalMileage()
        
        XCTAssertEqual(vehicleMileageVm.totalMileage, 160)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
