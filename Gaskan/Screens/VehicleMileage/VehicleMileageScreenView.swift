//
//  VehicleMileageScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 31/03/23.
//

import SwiftUI

struct VehicleMileageScreenView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var vehicleMileageViewModel: VehicleMileageViewModel
    @StateObject private var vehicleMileageResultViewModel: VehicleMileageResultViewModel = .init()
    @StateObject private var fuelEfficiencyViewModel: FuelEfficiencyViewModel = .init()
    
    @FocusState private var isFuelEfficiencyFocused: Bool
    @FocusState private var isFuelInFormFocused: Bool
    @FocusState private var isFuelCostPerUnitFocused: Bool
    
    /**
     this function for handling form editing
     it will set the form focused to `false` so it will stop edit in all textfield
     */
    private func handleFinishEditing() {
        isFuelEfficiencyFocused = false
        isFuelInFormFocused = false
        isFuelCostPerUnitFocused = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(idealHeight: 24.0)
                        .fixedSize()
                    // CONTENT-START: Choose Unit
                    Group {
                        Text("Choose Unit")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                        
                        UnitDropdownView(shouldShowDropdown: $vehicleMileageViewModel.shouldShowDropdown,
                                         selectedOption: $vehicleMileageViewModel.selectedOption,
                                         placeholder: "Unit",
                                         options: UnitData.unitOptions,
                                         onOptionSelected: { option in

                            vehicleMileageViewModel.fuelEfficiencyForm = ""
                        }, isExpandingState: { isExpanding in
                            if isExpanding {
                                handleFinishEditing()
                            } else {
                                vehicleMileageViewModel.shouldShowDropdown = false
                            }
                        })
                    }
                    // CONTENT-END: Choose Unit
                    
                    // CONTENT-START: Fuel Efficiency
                    Group {
                        Text("Fuel Efficiency")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField(vehicleMileageViewModel.selectedOption == UnitData.metricOption ? "E.g. 10 KM/L" : "E.g. 10 M/G", text: $vehicleMileageViewModel.fuelEfficiencyForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(vehicleMileageViewModel.isFuelEfficiencyFormErrorInput ? Color.red : Color.black)
                            .onTapGesture {
                                vehicleMileageViewModel.shouldShowDropdown = false
                            }
                            .onChange(of: vehicleMileageViewModel.fuelEfficiencyForm) { newValue in
                                vehicleMileageViewModel.validateForm()
                                vehicleMileageViewModel.fuelEfficiencyForm = TextFieldUtil.handleDecimalInput(value: newValue)
                            }
                            .focused($isFuelEfficiencyFocused)
                        
                        if vehicleMileageViewModel.isFuelEfficiencyFormErrorInput {
                            Text(vehicleMileageViewModel.fuelEfficiencyFormErrorMessage)
                                .font(.sfMonoMedium(fontSize: 12.0))
                                .tracking(-1.96)
                                .foregroundColor(.red)
                        }
                        
                        NavigationLink(value: FuelEfficiencyRoutingPath()) {
                            Text("Don't know my fuel efficiency")
                                .font(.sfMonoLight(fontSize: 12.0))
                                .foregroundColor(.appTertiaryColor)
                                .underline()
                                .tracking(-1.06)
                        }
                    }
                    
                    // CONTENT-START: Fuel In
                    Group {
                        Text("Fuel in Tank")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField(vehicleMileageViewModel.selectedOption == UnitData.metricOption ? "E.g. 10 L" : "E.g. 10 G", text: $vehicleMileageViewModel.fuelInForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(vehicleMileageViewModel.isFuelInFormErrorInput ? Color.red : Color.black)
                            .onTapGesture {
                                vehicleMileageViewModel.shouldShowDropdown = false
                            }
                            .onChange(of: vehicleMileageViewModel.fuelInForm) { newValue in
                                vehicleMileageViewModel.validateForm()
                                vehicleMileageViewModel.fuelInForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                
                            }
                            .focused($isFuelInFormFocused)
                        
                        if vehicleMileageViewModel.isFuelInFormErrorInput {
                            Text(vehicleMileageViewModel.fuelInFormErrorMessage)
                                .font(.sfMonoMedium(fontSize: 12.0))
                                .tracking(-1.96)
                                .foregroundColor(.red)
                        }
                    }
                    // CONTENT-END: Fuel In
                    
                    // CONTENT-START: Fuel Cost per Unit
                    Group {
                        Text("Fuel Cost per \(vehicleMileageViewModel.selectedOption == UnitData.metricOption ? "Liter" : "Gallon") (optional)")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField("E.g. 100", text: $vehicleMileageViewModel.fuelCostPerUnitForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(.black)
                            .onTapGesture {
                                vehicleMileageViewModel.shouldShowDropdown = false
                            }
                            .onChange(of: vehicleMileageViewModel.fuelCostPerUnitForm) { newValue in
                                vehicleMileageViewModel.fuelCostPerUnitForm = TextFieldUtil.handleDecimalInput(value: newValue)
                            }
                            .focused($isFuelCostPerUnitFocused)
                    }
                    // CONTENT-END: Fuel Cost per Unit
                    
                    Spacer().onTapGesture {
                        handleFinishEditing()
                    }
                    
                    // CONTENT-START: Calculate & Reset Button
                    Group {
                        Button {
                            handleFinishEditing()
                            vehicleMileageViewModel.validateForm()
                            
                            if !vehicleMileageViewModel.fuelEfficiencyForm.isEmpty && !vehicleMileageViewModel.fuelInForm.isEmpty {
                                
                                vehicleMileageViewModel.calculateTotalMileage()
                                path.append(VehicleMileageResultRoutingPath())
                            }
                            
                        } label: {
                            Text("CALCULATE")
                                .frame(maxWidth: .infinity)
                                .font(.sfMonoBold(fontSize: 16.0))
                                .tracking(0.8)
                        }
                        .padding(16.0)
                        .foregroundColor(.white)
                        .background(
                            Rectangle().fill(Color.appSecondaryColor)
                        )
                        
                        Button {
                            handleFinishEditing()
                            vehicleMileageViewModel.resetFormData()
                        } label: {
                            Text("RESET")
                                .frame(maxWidth: .infinity)
                                .font(.sfMonoBold(fontSize: 16.0))
                                .tracking(0.8)
                        }
                        .padding(16.0)
                        .foregroundColor(Color.appSecondaryColor)
                        
                    }
                    // CONTENT-END: Calculate & Reset Button
                }
                .toolbar {
                    ToolbarItem(placement: .principal, content: {
                        Text("Vehicle Mileage Calculator")
                            .font(.sfMonoSemibold(fontSize: 17.0))
                            .tracking(-1.5)
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            handleFinishEditing()
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .scrollDisabled(geometry.size.height > 700 ? true : false)
        }
        .navigationDestination(for: VehicleMileageResultRoutingPath.self) { _ in
            VehicleMileageResultScreenView(
                path: $path,
                totalMileage: $vehicleMileageViewModel.totalMileage,
                fuelEfficiency: $vehicleMileageViewModel.fuelEfficiencyForm,
                fuelIn: $vehicleMileageViewModel.fuelInForm,
                fuelCostPerUnit: $vehicleMileageViewModel.fuelCostPerUnitForm,
                selectedUnit: $vehicleMileageViewModel.selectedOption
            )
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environmentObject(vehicleMileageResultViewModel)
        }
        .navigationDestination(for: FuelEfficiencyRoutingPath.self) { _ in
            FuelEfficiencyScreenView(path: $path, fuelEfficiencyValue: $vehicleMileageViewModel.fuelEfficiencyForm, selectedOption: $vehicleMileageViewModel.selectedOption)
                .environmentObject(fuelEfficiencyViewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
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
        .background(Color.appPrimaryColor)

    }
}

struct VehicleMileageScreenView_Previews: PreviewProvider {
    struct VehicleMileageScreenPreviewer: View {
        @State private var path = NavigationPath()
        var body: some View {
            VehicleMileageScreenView(path: $path)
        }
    }
    
    static var previews: some View {
        VehicleMileageScreenPreviewer()
    }
}
