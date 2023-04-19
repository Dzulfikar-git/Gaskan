//
//  GaskanApp.swift
//  Gaskan
//
//  Created by Dzulfikar on 31/03/23.
//

import SwiftUI

@main
struct GaskanApp: App {
    let persistenceController = PersistenceController.shared
    @State private var path: NavigationPath = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var locationDataManager: LocationDataManager = .shared
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(locationDataManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .foregroundColor(Color.black)
                .preferredColorScheme(.light)
        }
    }
}
