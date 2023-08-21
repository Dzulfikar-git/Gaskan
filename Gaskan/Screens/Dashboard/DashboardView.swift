//
//  DashboardView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 12/04/23.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var locationDataManager: LocationDataManager
    @EnvironmentObject private var dashboardViewModel: DashboardViewModel
    
    @StateObject private var vehicleMileageViewModel: VehicleMileageViewModel = .init()
    @StateObject private var refuelViewModel: RefuelViewModel = .init()
    @StateObject private var newTripViewModel: NewTripViewModel = .init()
    
    @Binding var path: NavigationPath
    
    @AppStorage("isCalculated") private var isCalculated = false
    
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling = false
    @State private var buttonTimer: Timer?
    
    @State private var isEditCalculation = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(idealHeight: 64)
                            .fixedSize()
                        
                        Text("Calculation Result")
                            .font(.sfMonoBold(fontSize: 24))
                            .tracking(-1.5)
                        
                        if locationDataManager.isDriving {
                            Label("Is Driving", systemImage: "car.circle")
                        }
                        
                        Spacer()
                            .frame(idealHeight: 32)
                            .fixedSize()
                        
                        CardView(
                            title: "Your Vehicle’s Remaining Mileage",
                            description: dashboardViewModel.formatDateToString(date: dashboardViewModel.mileageDate),
                            value: String(format: "%.2f", dashboardViewModel.remainingMileage),
                            unit: dashboardViewModel.unit == UnitData.metricOption ? "  km" : "  miles",
                            isShowButton: items.contains(where: { dashboardViewModel.getCalculationType(type: String($0.type ?? "")) == CalculationType.newCalculation })) {
                                path.append(RefuelRoutingPath())
                            } onClickedMinus: {
                                path.append(NewTripRoutingPath())
                            }
                        
                        HStack {
                            ChildCardView(
                                title: "Fuel Efficiency",
                                value: String(format: "%.2f", dashboardViewModel.fuelEfficiency),
                                unit: dashboardViewModel.unit == UnitData.metricOption ? "KM/L" : "M/G"
                            )
                            
                            ChildCardView(
                                title: "Total Fuel Costs",
                                value: "\(dashboardViewModel.totalCosts)"
                            )
                        }
                        
                        if (!items.isEmpty) {
                            HStack {
                                Text("History")
                                    .font(.sfMonoBold(fontSize: 16.0))
                                    .foregroundColor(.appTertiaryColor)
                                    .tracking(-1.41)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        isEditCalculation.toggle()
                                    }
                                } label: {
                                    Text(isEditCalculation ? "Done" : "Edit Calculation")
                                        .font(.sfMonoRegular(fontSize: 12.0))
                                        .underline(true)
                                        .foregroundColor(.appTertiaryColor)
                                        .tracking(-1.06)
                                }

                            }
                            
                            VStack(spacing: 0) {
                                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                    
                                    let calculationType: CalculationType = dashboardViewModel.getCalculationType(type: String(item.type ?? ""))
                         
                                    let mileageAmount: Double = Double(item.totalMileage)
                                    
                                    let date = item.timestamp
                                    
                                    HistoryView(
                                        calculationType: calculationType,
                                        mileageAmount: mileageAmount,
                                        unit: dashboardViewModel.unit,
                                        date: date,
                                        isShowDeleteButton: $isEditCalculation,
                                        onDelete: {
                                            dashboardViewModel.updateRemainingMileage(items: Array(items) as [Item])
                                            dashboardViewModel.deleteItem(viewContext: viewContext,item: item)
                                        }
                                    )
                                    .frame(width: geometry.size.width)
                                    .fixedSize()
                                    .onAppear {
                                        dashboardViewModel.updateRemainingMileage(items: Array(items) as [Item])
                                    }
                                }
                            }
                        }
                        else {
                            // Add a default view to the VStack when items is empty
                            Text("No items found")
                            .onAppear{
                                dashboardViewModel.remainingMileage = 0
                                dashboardViewModel.fuelEfficiency = 0
                                dashboardViewModel.totalCosts = 0
                            }
                            .font(.sfMonoBold(fontSize: 16.0))
                            .foregroundColor(.appTertiaryColor)
                            .tracking(-1.41)
                            
                        }
                        
                        Spacer()
                            .frame(idealHeight: 84)
                            .fixedSize()
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    // Set the initial scroll offset to the current content offset
                                    scrollOffset = proxy.frame(in: .global).minY
                                }
                                .onChange(of: proxy.frame(in: .global).minY) { newValue in
                                    self.buttonTimer?.invalidate()
                                    self.buttonTimer = nil
                                    
                                    scrollOffset = newValue
                                    withAnimation {
                                        isScrolling = true
                                    }
                                    
                                    self.buttonTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                        withAnimation {
                                            isScrolling = false
                                        }
                                    }
                                }
                        }
                    )
                }
                
                if !isScrolling {
                    VStack {
                        Spacer()
                        
                        Button {
                            path.append(VehicleMileageRoutingPath())
                        } label: {
                            Text("NEW CALCULATION")
                                .frame(maxWidth: .infinity)
                                .font(.sfMonoBold(fontSize: 16.0))
                                .tracking(0.8)
                        }
                        .padding(16.0)
                        .foregroundColor(.white)
                        .background(
                            Rectangle().fill(Color.appSecondaryColor)
                        )
                        
                        Spacer().fixedSize().frame(maxHeight: 16)
                    }
                    .transition(.move(edge: .bottom)) // add transition modifier
                }
            }
        }
        .onAppear{
            if !isCalculated {
                path.append(VehicleMileageRoutingPath())
            }
            
            dashboardViewModel.updateRemainingMileage(items: Array(items) as [Item])
        }
        .navigationDestination(for: VehicleMileageRoutingPath.self) { _ in
                VehicleMileageScreenView(path: $path)
                .environmentObject(vehicleMileageViewModel)
        }
        .navigationDestination(for: RefuelRoutingPath.self) { _ in
            RefuelScreenView(path: $path, selectedOption: $dashboardViewModel.unit)
                .environmentObject(refuelViewModel)
        }
        .navigationDestination(for: NewTripRoutingPath.self) { _ in
            NewTripScreenView(path: $path, selectedOption: $dashboardViewModel.unit, totalMileage: Float(dashboardViewModel.remainingMileage))
                .environmentObject(newTripViewModel)
        }
        .padding([.horizontal], 16.0)
        .padding([.top], 1.0)
        .background(Image("BackgroundNoise")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .blendMode(.multiply)
            .opacity(0.05) // adjust the opacity of the noise texture
            .ignoresSafeArea())
        .background(
            Image("BackgroundGradient")
                .resizable()
                .scaledToFit()
                .offset(x: -100, y: -100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .ignoresSafeArea()
        )
        .background(
            Image("BackgroundPath")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .ignoresSafeArea()
        )
        .background(Color.appPrimaryColor.ignoresSafeArea())
        .ignoresSafeArea()
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    struct DashboardScreenPreviewer: View {
        @State private var path = NavigationPath()
        var body: some View {
            DashboardView(path: $path)
        }
    }
    
    static var previews: some View {
        DashboardScreenPreviewer()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(DashboardViewModel.shared)
    }
}
