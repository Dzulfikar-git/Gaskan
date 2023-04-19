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
    
    @Binding var path: NavigationPath
    
    @AppStorage("isCalculated") private var isCalculated = false
    
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling = false
    @State private var buttonTimer: Timer?
    
    @State private var isEditCalculation = false
    
    @State private var remainingMileage: Double = 0
    @State private var mileageDate: Date?
    @State private var unit: UnitDropdownOption? = UnitData.metricOption
    
    @State private var fuelEfficiency: Double = 0
    
    @State private var totalCosts: Int = 0
    
    @State private var prevMileage: Double = 0
    
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
                            description: formatDateToString(date: mileageDate),
                            value: String(format: "%.2f", remainingMileage),
                            unit: unit == UnitData.metricOption ? "  km" : "  miles",
                            isShowButton: items.contains(where: { getCalculationType(type: String($0.type ?? "")) == CalculationType.newCalculation })) {
                                path.append(RefuelRoutingPath())
                            } onClickedMinus: {
                                path.append(NewTripRoutingPath())
                            }
                        
                        HStack {
                            ChildCardView(
                                title: "Fuel Efficiency",
                                value: String(format: "%.2f", fuelEfficiency),
                                unit: unit == UnitData.metricOption ? "KM/L" : "M/G"
                            )
                            
                            
                            ChildCardView(
                                title: "Total Fuel Costs",
                                value: "\(totalCosts)"
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
                                    
                                    let calculationType: CalculationType = getCalculationType(type: String(item.type ?? ""))
                                    
                                    let mileageAmount: Double =  Double(item.totalMileage)
                                    
                                    let date = item.timestamp
                                    
                                    HistoryView(
                                        calculationType: calculationType,
                                        mileageAmount: mileageAmount,
                                        date: date,
                                        isShowDeleteButton: $isEditCalculation,
                                        onDelete: {
                                            updateRemainingMileage()
                                            deleteItem(item: item)
                                        }
                                    )
                                    .frame(width: geometry.size.width)
                                    .fixedSize()
                                    .onAppear {
                                        updateRemainingMileage()
                                    }
                                }
                            }
                        }
                        else {
                            // Add a default view to the VStack when items is empty
                            Text("No items found").onAppear{
                                remainingMileage = 0
                                fuelEfficiency = 0
                                totalCosts = 0
                            }
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
            
            updateRemainingMileage()
        }
        .navigationDestination(for: VehicleMileageRoutingPath.self) { _ in
                VehicleMileageScreenView(path: $path)
        }
        .navigationDestination(for: RefuelRoutingPath.self) { _ in
                RefuelScreenView(path: $path, selectedOption: $unit)
        }
        .navigationDestination(for: NewTripRoutingPath.self) { _ in
            NewTripScreenView(path: $path, selectedOption: $unit, totalMileage: Float(remainingMileage))
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
    
    private func updateRemainingMileage() {
        // Update the UI asynchronously
        DispatchQueue.main.async {
            withAnimation {
                if let lastItem = items.last {
                    remainingMileage = Double(lastItem.totalMileage)
                    print("[updateRemainingMileage][lastItem.fuelEfficiency]", lastItem.fuelEfficiency)
                    mileageDate = lastItem.timestamp
                    fuelEfficiency = Double(lastItem.fuelEfficiency)
                    totalCosts = Int(lastItem.totalFuelCost)
                    unit = getUnit(unit: String(lastItem.unit ?? ""))
                    
                    // Loop through the remaining items in the array and adjust the remainingMileage value based on their calculationType
                    for index in (0..<items.count).reversed() {
                        let item = items[index]
                        let calculationType = getCalculationType(type: String(item.type ?? ""))
                        print("[updateRemainingMileage][calculationType]", calculationType)
                        
                        let mileageAmount = Double(item.totalMileage)
                        print("[updateRemainingMileage][mileageAmount]", mileageAmount)
                        
                        let fuelEff = Double(item.fuelEfficiency)
                        
                        let totalFuelCost = Int(item.totalFuelCost)
                        
                        switch calculationType {
                        case .refuel:
                            remainingMileage += mileageAmount
                            fuelEfficiency = fuelEff
                            totalCosts += totalFuelCost
                        case .newTrip:
                            remainingMileage -= mileageAmount
                            totalCosts -= totalFuelCost
                        default:
                            break
                        }
                    }
                    
                    print("[updateRemainingMileage][remainingMileage]", remainingMileage)
                } else {
                    remainingMileage = 0
                    mileageDate = nil
                    fuelEfficiency = 0
                    totalCosts = 0
                }
            }
        }
    }
    
    private func getUnit(unit: String) -> UnitDropdownOption? {
        print("[getUnit][unit]", unit)
        print("[getUnit][Int64(UnitData.metricOption.hashValue)]", Int64(UnitData.metricOption.hashValue))
        print("[getUnit][Int64(UnitData.usOption.hashValue)]", Int64(UnitData.usOption.hashValue))
        
        switch unit {
        case UnitData.metricOption.value:
            return UnitData.metricOption
        case UnitData.usOption.value:
            return UnitData.usOption
        default:
            return nil
        }
    }
    
    private func deleteAllItems() {
        for item in items {
            deleteItem(item: item)
        }
    }
    
    private func deleteItem(item: Item) {
        withAnimation {
            viewContext.delete(item)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getCalculationType(type: String) -> CalculationType {
        switch type {
        case CalculationType.newTrip.rawValue:
            return .newTrip
        case CalculationType.refuel.rawValue:
            return .refuel
        case CalculationType.newCalculation.rawValue:
            return .newCalculation
        default:
            return .newCalculation
        }
        

    }
    
    func getMileageAmount(totalMileage: Double, calculationType: CalculationType?) -> Double {
        var mileageAmount: Double
        switch calculationType {
            
        case .refuel:
            mileageAmount = totalMileage - prevMileage
            
            return mileageAmount
            
        case .newTrip:
            mileageAmount = prevMileage - totalMileage
            
            
            return mileageAmount
        case .newCalculation:
            mileageAmount = totalMileage
            
            return mileageAmount
        default:
            return 0
        }
        
        //        var mileageAmount: Double
        //        if (prevMileage > totalMileage) {
        //            mileageAmount = prevMileage - totalMileage
        //            prevMileage = totalMileage
        //
        //
        //        } else {
        //            mileageAmount = totalMileage - prevMileage
        //            prevMileage = tota
        //        }
        
        
        //        return mileageAmount
    }
    
    func formatDateToString(date: Date?) -> String {
        if (date == nil) {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date!) {
            dateFormatter.dateFormat = "'Today', HH:mm"
        } else if calendar.isDateInYesterday(date!) {
            dateFormatter.dateFormat = "'Yesterday', HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM, HH:mm"
        }
        
        let dateString = dateFormatter.string(from: date!)
        
        return dateString
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
    }
}