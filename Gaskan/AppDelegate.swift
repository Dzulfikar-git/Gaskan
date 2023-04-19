//
//  AppDelegate.swift
//  Gaskan
//
//  Created by Dzulfikar on 13/04/23.
//

import UIKit
import BackgroundTasks

class AppDelegate: UIResponder, UIApplicationDelegate {
    var locationDataManager: LocationDataManager = .shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: AppConstants.backgroundTaskIdentifier,
            using: nil) { task in
                task.setTaskCompleted(success: true)
                switch self.locationDataManager.locationManager.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationDataManager.enable()
                    break;
                default:
                    self.locationDataManager.disable()
                    break;
                }
            }
        self.scheduleTrackingRefresh()
        return true
    }
    
    func scheduleTrackingRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: AppConstants.backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("background tracking refresh scheduled")
        } catch {
            print("Couldn't schedule app refresh \(error.localizedDescription)")
        }
    }
}
