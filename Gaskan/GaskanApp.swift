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
    
    var body: some Scene {
        WindowGroup {
//            DashboardView(path: $path)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ContentView()
            MainScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
