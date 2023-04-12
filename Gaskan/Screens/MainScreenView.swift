//
//  MainScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 31/03/23.
//
//  This MainScreenView will be used as `EntryPoint` of our app.

import SwiftUI

struct MainScreenView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @State var showVehicleMileage = false
    @State private var path: NavigationPath = .init()
    
    var body: some View {
        NavigationStack(path: $path) {
            if isFirstLaunch {
                OnboardingView(path: $path)
                    .onDisappear {
                        withAnimation {
                            showVehicleMileage = true
                        }
                    }
            } else if showVehicleMileage {
                withAnimation(.easeInOut(duration: 0.5)) {
                    VehicleMileageScreenView(path: $path)
                }
            }
        }.onAppear {
            if !isFirstLaunch {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showVehicleMileage = true
                }
            }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
