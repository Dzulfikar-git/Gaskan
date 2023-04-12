//
//  MainScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 31/03/23.
//
//  This MainScreenView will be used as `EntryPoint` of our app.

import SwiftUI

struct MainScreenView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var showDashboard = true
    @State private var path: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            if showDashboard {
                OnboardingView(onFinish: { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isFirstLaunch = false
                        showDashboard = false
                    
                        path.removeLast(path.count)
                    }
                }).onAppear {
                    if !isFirstLaunch {
                        showDashboard = false
                    }
                }
            } else {
                VehicleMileageScreenView(path: $path)
            }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
