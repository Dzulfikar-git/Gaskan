//
//  VehicleMileageResultScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct VehicleMileageResultScreenView: View {
    @State private var isExampleExpanding: Bool = false
    
    @Binding var totalMileage: Double
    @Binding var selectedUnit: UnitDropdownOption?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(idealHeight: 24.0)
                    .fixedSize()
                
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Vehicle Mileage")
                                .font(.sfMonoBold(fontSize: 16))
                                .tracking(0.8)
                            
                            Text("How many mileage you could travel with your fuel? ")
                                .font(.sfMonoRegular(fontSize: 12))
                                .tracking(-0.38)
                        }
                        Spacer(minLength: 32.0)
                        Text(String(totalMileage))
                            .font(.sfMonoBold(fontSize: 28))
                            .tracking(1.4)
                        + Text(selectedUnit == UnitData.metricOption ? "  km" : "  miles")
                            .font(.sfMonoRegular(fontSize: 14))
                            .tracking(0.7)
                    }
                    .foregroundColor(.white)
                    .padding(16.0)
                    .background(Color.appSecondaryColor)
                }
                .padding(8.0)
                .border(Color.appSecondaryColor, width: 2.0)
                .padding([.bottom], 16.0)
                
                ZStack {
                    VStack(alignment: .leading) {
                        Text("How do we get the result?")
                            .font(.sfMonoSemibold(fontSize: 18.0))
                            .tracking(-1.06)
                        Text("Mileage = Fuel Efficiency x Fuel in")
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
                            Text("Fuel in")
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
                                    Text("Mileage = Fuel Efficiency x Fuel in")
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
                Spacer()
            }
            .padding([.horizontal], 16.0)
        }
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
}

struct VehicleMileageResultScreenView_Previews: PreviewProvider {
    struct VehicleMileageResultScreenPreviewer: View {
        @State private var totalMileage: Double = 0
        @State private var selectedOption: UnitDropdownOption? = UnitData.metricOption
        
        var body: some View {
            VehicleMileageResultScreenView(totalMileage: $totalMileage, selectedUnit: $selectedOption)
        }
    }
    
    static var previews: some View {
        VehicleMileageResultScreenPreviewer()
    }
}
