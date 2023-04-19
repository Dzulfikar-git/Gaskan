//
//  FuelEfficiencyResultScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct FuelEfficiencyResultScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var path: NavigationPath
    @Binding var fuelEfficiencyValue: String
    @Binding var selectedUnit: UnitDropdownOption?
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Fuel Efficiency")
                            .font(.sfMonoBold(fontSize: 16.0))
                            .tracking(0.8)
                            .padding([.bottom], 4.0)
                        
                        Text("How many distance the vehicle can travel per unit of fuel consumed?")
                            .font(.custom("SFMono-Regular", size: 12))
                            .tracking(-0.38)
                    }
                    Spacer()
                    
                    Text(String(fuelEfficiencyValue))
                        .font(.sfMonoBold(fontSize: 28.0))
                        .tracking(1.4)
                    +
                    Text(selectedUnit == UnitData.metricOption ? "  km/l" : "  m/g")
                        .font(.system(size: 14.0))
                        .fontWeight(.regular)
                        .tracking(0.7)
                }
                .padding(12.0)
                .foregroundColor(.appPrimaryColor)
                .background(Color.appSecondaryColor)
            }
            .padding(8.0)
            .border(Color.appSecondaryColor)
            .padding([.bottom], 8.0)
            
            ZStack {
                VStack(alignment: .leading) {
                    Text("How do we get the result?")
                        .font(.sfMonoSemibold(fontSize: 18.0))
                        .tracking(-1.06)
                    
                    Text("Fuel Efficiency = Distance / Fuel Consumed")
                        .font(.sfMonoRegular(fontSize: 12.0))
                        .tracking(-0.59)
                        .padding(8.0)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.appSecondaryColor)
                    
                    Text("The formula")
                        .font(.sfProRegular(fontSize: 14.0))
                    +
                    Text(" divides the distance traveled by the amount of fuel consumed during that journey ")
                        .font(.sfProSemiboldItalic(fontSize: 14.0))
                        .foregroundColor(Color.appTertiaryColor)
                    +
                    Text(".The resulting number indicates how many units of distance can be traveled with a single unit of fuel.")
                        .font(.sfProRegular(fontSize: 14.0))
                }
            }
            .padding(12.0)
            .border(Color.appTertiaryColor)
            
            Spacer()
            
            Button {
                path.removeLast(1)
            } label: {
                Text("USE THIS RESULT TO CALCULATE VEHICLE MILEAGE")
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
        .onAppear{
            print("[fuelEfficiencyValue]", fuelEfficiencyValue)
        }
        .padding([.all], 16.0)
        .textFieldStyle(.plain).autocorrectionDisabled()
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Calculation Result")
                    .font(.sfMonoSemibold(fontSize: 17.0))
                    .tracking(-1.5)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct FuelEfficiencyResultScreenView_Previews: PreviewProvider {
    struct FuelEfficiencyResultScreenViewPreviewer: View {
        @State private var path: NavigationPath = NavigationPath()
        @State private var selectedUnit: UnitDropdownOption? = UnitData.metricOption
        @State private var fuelEfficiencyValue: String = "0.0"
        var body: some View {
            FuelEfficiencyResultScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedUnit: $selectedUnit)
        }
    }
    static var previews: some View {
        FuelEfficiencyResultScreenViewPreviewer()
    }
}
