//
//  FuelEfficiencyScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct FuelEfficiencyScreenView: View {
    // STATE START: navigation path routing state
    @Binding var path: NavigationPath
    // STATE END: navigation routing state
    
    // STATE START: fuel efficiency value
    @Binding var fuelEfficiencyValue: String
    // STATE END: fuel efficiency value
    
    // STATE START: dropdown state
    @State private var shouldShowDropdown: Bool = false
    @State private var isDropdownExpanding: Bool = false
    // STATE END: dropdown state
    
    // STATE START: unit selection state
    @Binding var selectedOption: UnitDropdownOption?
    // STATE END: unit selection state
    
    // STATE START: distance view selected state
    @State private var selectedDistanceView: Int = 0
    // STATE END: distance view selected state
    
    // STATE START: distance form state
    @State private var distanceForm: String = ""
    @State private var isDistanceFormErrorInput: Bool = false
    @State private var distanceFormErrorMessage: String = ""
    @FocusState private var isDistanceFormFocused: Bool
    // STATE END: distance form state
    
    // STATE START: odometer start form state
    @State private var odometerStartForm: String = ""
    @State private var isOdometerStartFormErrorInput: Bool = false
    @State private var odometerStartFormErrorMessage: String = ""
    @FocusState private var isOdometerStartFormFocused: Bool
    // STATE END: odometer start form state
    
    // STATE START: odometer end form state
    @State private var odometerEndForm: String = ""
    @State private var isOdometerEndFormErrorInput: Bool = false
    @State private var odometerEndFormErrorMessage: String = ""
    @FocusState private var isOdometerEndFormFocused: Bool
    // STATE END: odometer start form state
    
    // STATE START: fuel consumed form state
    @State private var fuelConsumedForm: String = ""
    @State private var isFuelConsumedFormErrorInput: Bool = false
    @State private var fuelConsumedFormErrorMessage: String = ""
    @FocusState private var isFuelConsumedFormFocused: Bool
    // STATE END: fuel consumed form state
    
    // STATE START: calculate button state
    @State private var isCalculatedButtonPressed: Bool = false
    // END START: calculate button state
    
    // function for handling finish editing false.
    // it will set the form focused to `false` so it will stop edit in all textfield
    private func handleFinishEditing() {
        isDistanceFormFocused = false
        isOdometerStartFormFocused = false
        isOdometerEndFormFocused = false
        isFuelConsumedFormFocused = false
    }
    
    /** Function to handle empty form validaton
     *  @param `formInputErrorState` for form input error state binding
     *  @param `formInputErrorMessageState` for error message
     *  @param `errorState` state of the error either true or false to set error state data
     */
    private func handleEmptyFormValidation(formInputErrorState: Binding<Bool>, formInputErrorMessageState: Binding<String>, errorState: Bool) {
        if errorState {
            formInputErrorState.wrappedValue = true
            formInputErrorMessageState.wrappedValue = "Please fill the field !"
        } else {
            formInputErrorState.wrappedValue = false
            formInputErrorMessageState.wrappedValue = ""
        }
    }
    
    /** Function for handling calculation.
     * it will check the selected distance view if it is by `Distance` or `Odometer`
     * then it will check the form value, if it is empty then it will do nothing
     * if not empty, it will calculate by formula `fuel efficiency = distance / fuel consumed`
     * then change state of calculate button pressed to be true in order to navigate screen to fuel efficiency result.
     */
    private func handleCalculate() {
        if selectedDistanceView == 0 { // using distance
            if distanceForm.isEmpty {
                handleEmptyFormValidation(formInputErrorState: self.$isDistanceFormErrorInput, formInputErrorMessageState: self.$distanceFormErrorMessage, errorState: true)
            }
            
            if fuelConsumedForm.isEmpty {
                handleEmptyFormValidation(formInputErrorState: self.$isFuelConsumedFormErrorInput, formInputErrorMessageState: self.$fuelConsumedFormErrorMessage, errorState: true)
            }
            
            if !fuelConsumedForm.isEmpty && !distanceForm.isEmpty {
                fuelEfficiencyValue = String(format: "%.2f", ((Double(distanceForm) ?? 0) / (Double(fuelConsumedForm) ?? 0)).rounded(.toNearestOrAwayFromZero))
                print("[fuelEfficiencyValue]", fuelEfficiencyValue)
                isCalculatedButtonPressed = true
            }
            
        } else { // using odometer
            if odometerStartForm.isEmpty {
                handleEmptyFormValidation(formInputErrorState: self.$isOdometerStartFormErrorInput, formInputErrorMessageState: self.$odometerStartFormErrorMessage, errorState: true)
            }
            
            if odometerEndForm.isEmpty {
                handleEmptyFormValidation(formInputErrorState: self.$isOdometerEndFormErrorInput, formInputErrorMessageState: self.$odometerEndFormErrorMessage, errorState: true)
            }
            
            if fuelConsumedForm.isEmpty {
                handleEmptyFormValidation(formInputErrorState: self.$isFuelConsumedFormErrorInput, formInputErrorMessageState: self.$fuelConsumedFormErrorMessage, errorState: true)
            }
            
            if !odometerStartForm.isEmpty && !odometerEndForm.isEmpty && !fuelConsumedForm.isEmpty {
                fuelEfficiencyValue = String(format: "%.2f", (((Double(odometerEndForm) ?? 0.0) - (Double(odometerStartForm) ?? 0.0)) / (Double(fuelConsumedForm) ?? 0.0)).rounded(.toNearestOrAwayFromZero))
                print("[fuelEfficiencyValue]", fuelEfficiencyValue)
                isCalculatedButtonPressed = true
            }
            
        }
        
    }
    
    // function for resetting form values.
    // it will set the value of all form to be `""` equals to empty string
    private func handleReset() {
        distanceForm = ""
        odometerStartForm = ""
        odometerEndForm = ""
        fuelConsumedForm = ""
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(idealHeight: 24.0)
                        .fixedSize()
                    
                    DistanceSegmentedControlView(preselectedIndex: $selectedDistanceView, options: ["DISTANCE", "ODOMETER"])
                    
                    // View Selection
                    if selectedDistanceView == 0 {
                        
                        // CONTENT-START: Distance
                        Group {
                            Text("Distance")
                                .font(.sfMonoRegular(fontSize: 15))
                                .tracking(-1.32)
                                .foregroundColor(.appTertiaryColor)
                                .padding([.top], 8.0)
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 100 KM" : "E.g. 100 Miles", text: $distanceForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12.0)
                                .border(isDistanceFormErrorInput ? Color.red : Color.black)
                                .onTapGesture {
                                    shouldShowDropdown = false
                                }
                                .onChange(of: distanceForm) { newValue in
                                    handleEmptyFormValidation(formInputErrorState: self.$isDistanceFormErrorInput, formInputErrorMessageState: self.$distanceFormErrorMessage, errorState: newValue.isEmpty)
                                    distanceForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .focused($isDistanceFormFocused)
                            
                            if isDistanceFormErrorInput {
                                Text(distanceFormErrorMessage)
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
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 15000 KM" : "E.g. 1500 Miles", text: $odometerStartForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .border(isOdometerStartFormErrorInput ? Color.red : Color.black)
                                .onChange(of: odometerStartForm) { newValue in
                                    handleEmptyFormValidation(formInputErrorState: self.$isOdometerStartFormErrorInput, formInputErrorMessageState: self.$odometerStartFormErrorMessage, errorState: newValue.isEmpty)
                                    odometerStartForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .onTapGesture {
                                    shouldShowDropdown = false
                                }
                                .focused($isOdometerStartFormFocused)
                            
                            if isOdometerStartFormErrorInput {
                                Text(odometerStartFormErrorMessage)
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
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 15100 KM" : "E.g. 1600 Miles", text: $odometerEndForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .border(isOdometerEndFormErrorInput ? Color.red : Color.black)
                                .onChange(of: odometerEndForm) { newValue in
                                    handleEmptyFormValidation(formInputErrorState: self.$isOdometerEndFormErrorInput, formInputErrorMessageState: self.$odometerEndFormErrorMessage, errorState: newValue.isEmpty)
                                    odometerEndForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .onTapGesture {
                                    shouldShowDropdown = false
                                }
                                .focused($isOdometerEndFormFocused)
                            
                            if isOdometerEndFormErrorInput {
                                Text(odometerEndFormErrorMessage)
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
                        
                        TextField(selectedOption == UnitData.metricOption ? "E.g. 100 Liters" : "E.g. 100 Gallons", text: $fuelConsumedForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(isFuelConsumedFormErrorInput ? Color.red : Color.black)
                            .onChange(of: fuelConsumedForm) { newValue in
                                handleEmptyFormValidation(formInputErrorState: self.$isFuelConsumedFormErrorInput, formInputErrorMessageState: self.$fuelConsumedFormErrorMessage, errorState: newValue.isEmpty)
                                fuelConsumedForm = TextFieldUtil.handleDecimalInput(value: newValue)
                            }
                            .onTapGesture {
                                shouldShowDropdown = false
                            }
                            .focused($isFuelConsumedFormFocused)
                        
                        if isFuelConsumedFormErrorInput {
                            Text(fuelConsumedFormErrorMessage)
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
                        handleReset()
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
            .navigationDestination(isPresented: $isCalculatedButtonPressed, destination: {
                FuelEfficiencyResultScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedUnit: $selectedOption)
            })
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
        var body: some View {
                FuelEfficiencyScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedOption: $selectedOption)
        }
    }
    
    static var previews: some View {
        FuelEfficiencyScreenViewPreviewer()
    }
}
