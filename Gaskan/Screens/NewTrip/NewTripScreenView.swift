//
//  FuelEfficiencyScreenView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct NewTripScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var newTripViewModel: NewTripViewModel
    
    @Binding var path: NavigationPath
    @Binding var selectedOption: UnitDropdownOption?
    
    @FocusState private var isDistanceFormFocused: Bool
    @FocusState private var isOdometerStartFormFocused: Bool
    @FocusState private var isOdometerEndFormFocused: Bool
    
    var totalMileage: Float = 0.0
    
    // function for handling finish editing false.
    // it will set the form focused to `false` so it will stop edit in all textfield
    private func handleFinishEditing() {
        isDistanceFormFocused = false
        isOdometerStartFormFocused = false
        isOdometerEndFormFocused = false
    }
    
    /** Function for handling calculation.
     * it will check the selected distance view if it is by `Distance` or `Odometer`
     * then it will check the form value, if it is empty then it will do nothing
     * if not empty, it will calculate by formula `fuel efficiency = distance / fuel consumed`
     * then change state of calculate button pressed to be true in order to navigate screen to fuel efficiency result.
     */
    private func handleCalculate() {
        newTripViewModel.validateForm()
        if newTripViewModel.selectedDistanceView == 0 { // using distance
            if !newTripViewModel.distanceForm.isEmpty {
                if totalMileage <= Float(newTripViewModel.distanceForm) ?? 0.0 {
                    newTripViewModel.showAlert = true
                    newTripViewModel.alertTitle = "Distance Exceeds Total Mileage"
                    newTripViewModel.alertDescription = "Please input the distance below your current total mileage"
                    return
                }

                newTripViewModel.addItem(viewContext: viewContext, totalMileage: totalMileage, fuelEfficiency: (Float(newTripViewModel.fuelEfficiencyValue) ?? 0), unit: selectedOption!)
                path.removeLast(path.count)
            }
            
        } else { // using odometer
            if !newTripViewModel.odometerStartForm.isEmpty && !newTripViewModel.odometerEndForm.isEmpty {
                if totalMileage <= Float(newTripViewModel.distanceForm) ?? 0.0 {
                    newTripViewModel.showAlert = true
                    newTripViewModel.alertTitle = "Distance Exceeds Total Mileage"
                    newTripViewModel.alertDescription = "Please input the distance below your current total mileage"
                    return
                }
                
//                addItem()
                path.removeLast(path.count)
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
                    
                    DistanceSegmentedControlView(preselectedIndex: $newTripViewModel.selectedDistanceView, options: ["DISTANCE", "ODOMETER"])
                    
                    // View Selection
                    if newTripViewModel.selectedDistanceView == 0 {
                        
                        // CONTENT-START: Distance
                        Group {
                            Text("Distance")
                                .font(.sfMonoRegular(fontSize: 15))
                                .tracking(-1.32)
                                .foregroundColor(.appTertiaryColor)
                                .padding([.top], 8.0)
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 100 KM" : "E.g. 100 Miles", text: $newTripViewModel.distanceForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12.0)
                                .border(newTripViewModel.isDistanceFormErrorInput ? Color.red : Color.black)
                                .onTapGesture {
                                    newTripViewModel.shouldShowDropdown = false
                                }
                                .onChange(of: newTripViewModel.distanceForm) { newValue in
                                    newTripViewModel.validateForm()
                                    newTripViewModel.distanceForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .focused($isDistanceFormFocused)
                            
                            if newTripViewModel.isDistanceFormErrorInput {
                                Text(newTripViewModel.distanceFormErrorMessage)
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
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 15000 KM" : "E.g. 1500 Miles", text: $newTripViewModel.odometerStartForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .border(newTripViewModel.isOdometerStartFormErrorInput ? Color.red : Color.black)
                                .onChange(of: newTripViewModel.odometerStartForm) { newValue in
                                    newTripViewModel.validateForm()
                                    newTripViewModel.odometerStartForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .onTapGesture {
                                    newTripViewModel.shouldShowDropdown = false
                                }
                                .focused($isOdometerStartFormFocused)
                            
                            if newTripViewModel.isOdometerStartFormErrorInput {
                                Text(newTripViewModel.odometerStartFormErrorMessage)
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
                            
                            TextField(selectedOption == UnitData.metricOption ? "E.g. 15100 KM" : "E.g. 1600 Miles", text: $newTripViewModel.odometerEndForm)
                                .font(.sfMonoLight(fontSize: 14.0))
                                .tracking(-1.24)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .border(newTripViewModel.isOdometerEndFormErrorInput ? Color.red : Color.black)
                                .onChange(of: newTripViewModel.odometerEndForm) { newValue in
                                    newTripViewModel.validateForm()
                                    newTripViewModel.odometerEndForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                }
                                .onTapGesture {
                                    newTripViewModel.shouldShowDropdown = false
                                }
                                .focused($isOdometerEndFormFocused)
                            
                            if newTripViewModel.isOdometerEndFormErrorInput {
                                Text(newTripViewModel.odometerEndFormErrorMessage)
                                    .font(.sfMonoMedium(fontSize: 12.0))
                                    .tracking(-1.96)
                                    .foregroundColor(.red)
                            }
                        }
                        // CONTENT-END: Odometer End
                    }
                    
                    Spacer().onTapGesture {
                        handleFinishEditing()
                    }
                    
                    Button {
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
                        newTripViewModel.resetForm()
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
            .alert(isPresented: $newTripViewModel.showAlert) {
                Alert(title: Text(newTripViewModel.alertTitle), message: Text(newTripViewModel.alertDescription), dismissButton: .default(Text("OK")))
                    }
            .scrollDisabled(geometry.size.height > 700 ? true : false)
            .navigationBarTitleDisplayMode(.inline)
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
                    Text("New Trip Calculator")
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

struct NewTripScreenView_Previews: PreviewProvider {
    struct NewTripScreenViewPreviewer: View {
        @State var path: NavigationPath = NavigationPath()
        @State var fuelEfficiencyValue: String = "0.0"
        @State var selectedOption: UnitDropdownOption? = UnitData.metricOption
        @StateObject var newTripViewModel = NewTripViewModel()
        var body: some View {
                FuelEfficiencyScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyValue, selectedOption: $selectedOption)
                    .environmentObject(newTripViewModel)
        }
    }
    
    static var previews: some View {
        NewTripScreenViewPreviewer()
    }
}
