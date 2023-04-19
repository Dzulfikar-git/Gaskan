//
//  VehicleMileageResultScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct VehicleMileageResultScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var path: NavigationPath
    
    @State private var isExampleExpanding: Bool = false
    
    @Binding var totalMileage: Double
    @Binding var fuelEfficiency: String
    @Binding var fuelIn: String
    @Binding var fuelCostPerUnit: String

    @Binding var selectedUnit: UnitDropdownOption?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(idealHeight: 24.0)
                        .fixedSize()
                    
                    CardView(
                        title: "Vehicle Mileage",
                        description: "How many mileage you could travel with your fuel?",
                        value: String(format: "%.2f", totalMileage),
                        unit: selectedUnit == UnitData.metricOption ? "  km" : "  miles",
                        isShowButton: false) {
                            
                        } onClickedMinus: {
                            
                        }
                    
                    ZStack {
                        VStack(alignment: .leading) {
                            Text("How do we get the result?")
                                .font(.sfMonoSemibold(fontSize: 18.0))
                                .tracking(-1.06)
                            Text("Mileage = Fuel Efficiency x Fuel in Tank")
                                .font(.sfMonoRegular(fontSize: 12.0))
                                .tracking(-0.59)
                                .padding(8.0)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(Color.appSecondaryColor)
                            
                            (
                                Text("Mileage")
                                    .font(.sfProSemibold(fontSize: 14.0))
                                    .foregroundColor(.appTertiaryColor)
                                + Text(" refers to the distance traveled by the vehicle per unit of fuel")
                                    .font(.sfProRegular(fontSize: 14.0))
                                    .foregroundColor(.appTertiaryColor)
                            ).padding([.bottom], 4.0)
                            
                            (
                                Text("Fuel efficiency")
                                    .font(.sfProSemibold(fontSize: 14.0))
                                    .foregroundColor(.appTertiaryColor)
                                + Text(" refers to a measure of how much distance your vehicle can travel with a specific volume of fuel")
                                    .font(.sfProRegular(fontSize: 14.0))
                                    .foregroundColor(.appTertiaryColor)
                            ).padding([.bottom], 4.0)
                            
                            (
                                Text("Fuel in Tank")
                                    .font(.sfProSemibold(fontSize: 14.0))
                                    .foregroundColor(.appTertiaryColor)
                                + Text(" refers to the amount of fuel available to the vehicle for travel")
                                    .font(.sfProRegular(fontSize: 14.0))
                                    .foregroundColor(.appTertiaryColor)
                            ).padding([.bottom], 4.0)
                            
                        }
                        .padding([.horizontal], 16.0)
                        .padding([.vertical], 8.0)
                    }
                    .padding(8.0)
                    .border(Color.appSecondaryColor, width: 2)
                    
                    ZStack {
                        VStack(alignment: .leading) {
                            DisclosureGroup(isExpanded: $isExampleExpanding, content: {
                                VStack(alignment: .leading) {
                                    Divider()
                                        .frame(height: 1.0)
                                        .background(Color.appPrimaryColor)
                                        .padding([.bottom], 8.0)
                                    
                                    Text("Multiplying the fuel efficiency by the amount of fuel in the tank gives us the total distance the vehicle can travel before it runs out of fuel, which is the mileage.")
                                        .font(.sfProRegular(fontSize: 14.0))
                                        .padding([.bottom], 8.0)
                                    
                                    
                                    Text("For example, if a vehicle has a fuel efficiency of 30 miles per gallon (mpg) and a full tank of 15 gallons of fuel, then the mileage would be:")
                                        .font(.sfProRegular(fontSize: 14.0))
                                        .padding([.bottom], 8.0)
                                    
                                    Group {
                                        Text("Mileage = Fuel Efficiency x Fuel in Tank")
                                        Text("Mileage = 30 mpg x 15 gallons")
                                        Text("Mileage = 450 miles")
                                            .padding([.bottom], 8.0)
                                    }
                                    .font(.sfProRegular(fontSize: 14.0))
                                    
                                    Text("This means that the vehicle can travel 450 miles on a full tank of fuel, assuming that the fuel efficiency remains constant throughout the trip.")
                                        .font(.sfProRegular(fontSize: 14.0))
                                        .padding([.bottom], 8.0)
                                }
                            }, label: {
                                Text("Example")
                                    .font(.sfMonoSemibold(fontSize: 18))
                                    .tracking(-1.06)
                                    .foregroundColor(.appPrimaryColor)
                            })
                        }
                        .foregroundColor(.appPrimaryColor)
                        .padding([.horizontal], 16.0)
                        .accentColor(Color.appPrimaryColor)
                        .disclosureGroupStyle(CircleChevronDisclosureStyle())
                    }
                    .padding(8.0)
                    .border(Color.appSecondaryColor, width: 2)
                    .background(Color.appSecondaryColor)
                    .foregroundColor(.white)
                }
            }
            
            VStack {
                Spacer()
                
                Button {
                    deleteAllItems()
                    addItem()
                    
                    UserDefaults.standard.set(true, forKey: "isCalculated")
                    
                    path.removeLast(path.count)
                } label: {
                    Text("SAVE THIS RESULT")
                        .frame(maxWidth: .infinity)
                        .font(.sfMonoBold(fontSize: 16.0))
                        .tracking(0.8)
                }
                .padding([.vertical], 8.0)
                .foregroundColor(Color.appPrimaryColor)
                .background(
                    Rectangle().fill(Color.appSecondaryColor)
                )
            }
        }
        .padding([.horizontal], 16.0)
        .padding([.top], 1)
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
        .background(Color.appPrimaryColor)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Calculation Result")
                    .font(.sfMonoSemibold(fontSize: 17.0))
                    .tracking(-1.5)
            }
        }
        .scrollDisabled(!isExampleExpanding)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.type = CalculationType.newCalculation.rawValue
            print("[addItem][newItem.type]", newItem.type)
            newItem.timestamp = Date()
            newItem.totalMileage = Float(totalMileage)
            newItem.fuelEfficiency = Float(fuelEfficiency) ?? 0.0
            newItem.totalFuelCost = (Float(fuelIn) ?? 0.0) * (Float(fuelCostPerUnit) ?? 0.0)
            newItem.unit = selectedUnit?.value

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
}

struct VehicleMileageResultScreenView_Previews: PreviewProvider {
    struct VehicleMileageResultScreenPreviewer: View {
        @State private var path = NavigationPath()
        @State private var totalMileage: Double = 0
        @State private var fuelEfficiency: String = ""
        @State private var fuelIn: String = ""
        @State private var fuelCostPerUnit: String = ""
        
        @State private var selectedOption: UnitDropdownOption? = UnitData.metricOption
        
        var body: some View {
            VehicleMileageResultScreenView(path: $path, totalMileage: $totalMileage, fuelEfficiency: $fuelEfficiency, fuelIn: $fuelIn, fuelCostPerUnit: $fuelCostPerUnit, selectedUnit: $selectedOption)
        }
    }
    
    static var previews: some View {
        VehicleMileageResultScreenPreviewer()
    }
}
