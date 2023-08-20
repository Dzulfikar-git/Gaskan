//
//  FuelEfficiencyScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct FuelEfficiencyScreenView: View {
    @EnvironmentObject var fuelEfficiencyViewModel: FuelEfficiencyViewModel
    @Binding var path: NavigationPath
    
    @Binding var fuelEfficiencyValue: String
    @Binding var selectedOption: UnitDropdownOption?
    
    @FocusState private var isDistanceFormFocused: Bool
    @FocusState private var isOdometerStartFormFocused: Bool
    @FocusState private var isOdometerEndFormFocused: Bool
    @FocusState private var isFuelConsumedFormFocused: Bool
    
    @State private var isCalculatedButtonPressed: Bool = false
    
    private func handleFinishEditing() {
        isDistanceFormFocused = false
        isOdometerStartFormFocused = false
        isOdometerEndFormFocused = false
        isFuelConsumedFormFocused = false
    }
    
    /** Function for handling calculation.
     * it will check the selected distance view if it is by `Distance` or `Odometer`
     * then it will check the form value, if it is empty then it will do nothing
     * if not empty, it will calculate by formula `fuel efficiency = distance / fuel consumed`
     * then change state of calculate button pressed to be true in order to navigate screen to fuel efficiency result.
     */
    private func handleCalculate() {
        fuelEfficiencyViewModel.validateForm()
        if fuelEfficiencyViewModel.selectedDistanceView == 0 { // using distance
            if !fuelEfficiencyViewModel.fuelConsumedForm.isEmpty && !fuelEfficiencyViewModel.distanceForm.isEmpty {
                fuelEfficiencyValue = fuelEfficiencyViewModel.calculateFuelEfficiencyByDistance()
//                isCalculatedButtonPressed = true
                path.append(FuelEfficiencyResultRoutingPath())
            }
            
        } else { // using odometer
            if !fuelEfficiencyViewModel.odometerStartForm.isEmpty && !fuelEfficiencyViewModel.odometerEndForm.isEmpty && !fuelEfficiencyViewModel.fuelConsumedForm.isEmpty {
                fuelEfficiencyValue = fuelEfficiencyViewModel.calculateFuelEfficiencyByOdometer()
//                isCalculatedButtonPressed = true
                path.append(FuelEfficiencyResultRoutingPath())
            }
            
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(idealHeight: 24.0)
                        .fixedSize()
                    
                    DistanceSegmentedControlView(preselectedIndex: $fuelEfficiencyViewModel.selectedDistanceView, options: ["DISTANCE", "ODOMETER"])
                    
                    // View Selection
                    if fuelEfficiencyViewModel.selectedDistanceView == 0 {
                        
                        // CONTENT-START: Distance
                        Group {
                            Text("Distance")
                                .font(.sfMonoRegular(fontSize: 15))
                                .tracking(-1.32)
                                .foregroundColor(.appTertiaryColor)
                                .padding([.top], 8.0)
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 100 KM" : "E.g. 100 Miles", text: $fuelEfficiencyViewModel.distanceForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12.0)
                                .border(fuelEfficiencyViewModel.isDistanceFormErrorInput ? Color.red : Color.black)
                                .onTapGesture {
                                    fuelEfficiencyViewModel.shouldShowDropdown = false
                                }
                                .onChange(of: fuelEfficiencyViewModel.distanceForm) { newValue in
                                    fuelEfficiencyViewModel.validateForm()
                                    fuelEfficiencyViewModel.distanceForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .focused($isDistanceFormFocused)
                            
                            if fuelEfficiencyViewModel.isDistanceFormErrorInput {
                                Text(fuelEfficiencyViewModel.distanceFormErrorMessage)
                                    .font(.sfMonoMedium(fontSize: 12.0))
                                    .tracking(-1.96)
                                    .foregroundColor(.red)
                            }
                        }
                        // CONTENT-END: Distance
                    } else {
                        // CONTENT-START: Odometer Start
                        Group {
                            Text("Odometer Start")
                                .font(.sfMonoRegular(fontSize: 15))
                                .tracking(-1.32)
                                .foregroundColor(.appTertiaryColor)
                                .padding([.top], 8.0)
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 15000 KM" : "E.g. 1500 Miles", text: $fuelEfficiencyViewModel.odometerStartForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .border(fuelEfficiencyViewModel.isOdometerStartFormErrorInput ? Color.red : Color.black)
                                .onChange(of: fuelEfficiencyViewModel.odometerStartForm) { newValue in
                                    fuelEfficiencyViewModel.validateForm()
                                    fuelEfficiencyViewModel.odometerStartForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .onTapGesture {
                                    fuelEfficiencyViewModel.shouldShowDropdown = false
                                }
                                .focused($isOdometerStartFormFocused)
                            
                            if fuelEfficiencyViewModel.isOdometerStartFormErrorInput {
                                Text(fuelEfficiencyViewModel.odometerStartFormErrorMessage)
                                    .font(.sfMonoMedium(fontSize: 12.0))
                                    .tracking(-1.96)
                                    .foregroundColor(.red)
                            }
                        }
                        // CONTENT-START: Odometer Start
                        
                        // CONTENT-START: Odometer End
                        Group {
                            Text("Odometer End")
                                .font(.sfMonoRegular(fontSize: 15))
                                .tracking(-1.32)
                                .foregroundColor(.appTertiaryColor)
                                .padding([.top], 8.0)
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 15100 KM" : "E.g. 1600 Miles", text: $fuelEfficiencyViewModel.odometerEndForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .border(fuelEfficiencyViewModel.isOdometerEndFormErrorInput ? Color.red : Color.black)
                                .onChange(of: fuelEfficiencyViewModel.odometerEndForm) { newValue in
                                    fuelEfficiencyViewModel.validateForm()
                                    fuelEfficiencyViewModel.odometerEndForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .onTapGesture {
                                    fuelEfficiencyViewModel.shouldShowDropdown = false
                                }
                                .focused($isOdometerEndFormFocused)

                            if fuelEfficiencyViewModel.isOdometerEndFormErrorInput {
                                Text(fuelEfficiencyViewModel.odometerEndFormErrorMessage)
                                    .font(.sfMonoMedium(fontSize: 12.0))
                                    .tracking(-1.96)
                                    .foregroundColor(.red)
                            }
                        }
                        // CONTENT-END: Odometer End
                    }
                    
                    // CONTENT-START: Fuel Consumed
                    Group {
                        Text("Fuel Consumed")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField(selectedOption == UnitData.metricOption ? "E.g. 100 Liters" : "E.g. 100 Gallons", text: $fuelEfficiencyViewModel.fuelConsumedForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(fuelEfficiencyViewModel.isFuelConsumedFormErrorInput ? Color.red : Color.black)
                            .onChange(of: fuelEfficiencyViewModel.fuelConsumedForm) { newValue in
                                fuelEfficiencyViewModel.validateForm()
                                fuelEfficiencyViewModel.fuelConsumedForm = TextFieldUtil.handleDecimalInput(value: newValue)
                            }
                            .onTapGesture {
                                fuelEfficiencyViewModel.shouldShowDropdown = false
                            }
                            .focused($isFuelConsumedFormFocused)
                        
                        if fuelEfficiencyViewModel.isFuelConsumedFormErrorInput {
                            Text(fuelEfficiencyViewModel.fuelConsumedFormErrorMessage)
                                .font(.sfMonoMedium(fontSize: 12.0))
                                .tracking(-1.96)
                                .foregroundColor(.red)
                        }
                    }
                    // CONTENT-END: Fuel Consumed
                    
                    Spacer().onTapGesture {
                        handleFinishEditing()
                    }
                    
                    Button {
                        handleFinishEditing()
                        handleCalculate()
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
                        fuelEfficiencyViewModel.resetFormData()
                    } label: {
                        Text("RESET")
                            .frame(maxWidth: .infinity)
                            .font(.sfMonoBold(fontSize: 16.0))
                            .tracking(0.8)
                    }
                    .padding(16.0)
                    .foregroundColor(Color.appSecondaryColor)
                }
                .frame(height: geometry.size.height)
            }
            .scrollDisabled(geometry.size.height > 700 ? true : false)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FuelEfficiencyResultRoutingPath.self) { _ in
//                FuelEfficiencyResultScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedUnit: $selectedOption)
                VStack {
                    Text("ASD")
                }
//                .onAppear {
//                    print(path.count)
//                }
            }
//            .navigationDestination(isPresented: $isCalculatedButtonPressed, destination: {
//                FuelEfficiencyResultScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedUnit: $selectedOption)
//            })
            .padding([.horizontal], 16.0)
            .padding([.top], 1.0)
            .background(
                Image("BackgroundNoise")
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
                    Text("Fuel Efficiency Calculator")
                        .font(.sfMonoSemibold(fontSize: 17.0))
                        .tracking(-1.5)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        handleFinishEditing()
                    }
                }
            }
        }
    }
}

struct FuelEfficiencyScreenView_Previews: PreviewProvider {
    struct FuelEfficiencyScreenViewPreviewer: View {
        @State var path: NavigationPath = NavigationPath()
        @State var fuelEfficiencyValue: String = "0.0"
        @State var selectedOption: UnitDropdownOption? = UnitData.metricOption
        @StateObject var fuelEfficiencyScreenViewModel: FuelEfficiencyViewModel = .init()
        var body: some View {
                FuelEfficiencyScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedOption: $selectedOption)
                .environmentObject(fuelEfficiencyScreenViewModel)
        }
    }
    
    static var previews: some View {
        FuelEfficiencyScreenViewPreviewer()
    }
}
