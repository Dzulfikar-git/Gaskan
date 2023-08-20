//
//  RefuelScreenView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 16/04/23.
//

import SwiftUI

struct RefuelScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var refuelViewModel: RefuelViewModel
    
    @Binding var path: NavigationPath
    
    @Binding var selectedOption: UnitDropdownOption?
    
    @FocusState private var isFuelEfficiencyFocused: Bool
    @FocusState private var isFuelInFormFocused: Bool
    @FocusState private var isFuelCostPerUnitFocused: Bool
    
    // function for handling finish editing form.
    // it will set the form focused to `false` so it will stop edit in all textfield
    private func handleFinishEditing() {
        isFuelEfficiencyFocused = false
        isFuelInFormFocused = false
        isFuelCostPerUnitFocused = false
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
     * it will check the value of fuel efficiency and fuelin form,
     * if both form is empty, it will do nothing.
     * it not, then it will calculate by formula `total mileage = fuel efficiency * fuel in`
     * then change state of calculate button pressed to be true in order to navigate * screen to dashboard
     **/
    private func handleCalculate() {
        if !refuelViewModel.fuelEfficiencyForm.isEmpty && !refuelViewModel.fuelInForm.isEmpty {
            refuelViewModel.calculateTotalMileage()
            refuelViewModel.addItem(viewContext: viewContext, totalMileage: Float(refuelViewModel.totalMileage), fuelEfficiency: (Float(refuelViewModel.fuelEfficiencyForm) ?? 0), fuelInForm: (Float(refuelViewModel.fuelInForm) ?? 0), fuelCostPerUnit: (Float(refuelViewModel.fuelCostPerUnitForm) ?? 0), unit: selectedOption!)
            path.removeLast(path.count)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(idealHeight: 24.0)
                        .fixedSize()
                    
                    // CONTENT-START: Fuel Efficiency
                    Group {
                        Text("Fuel Efficiency")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField(selectedOption == UnitData.metricOption ? "E.g. 10 KM/L" : "E.g. 10 M/G", text: $refuelViewModel.fuelEfficiencyForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(refuelViewModel.isFuelEfficiencyFormErrorInput ? Color.red : Color.black)
                            .onTapGesture {
                                refuelViewModel.shouldShowDropdown = false
                            }
                            .onChange(of: refuelViewModel.fuelEfficiencyForm) { newValue in
                                refuelViewModel.validateForm()
                                refuelViewModel.fuelEfficiencyForm = TextFieldUtil.handleDecimalInput(value: newValue)
                            }
                            .focused($isFuelEfficiencyFocused)
                        
                        if refuelViewModel.isFuelEfficiencyFormErrorInput {
                            Text(refuelViewModel.fuelEfficiencyFormErrorMessage)
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
                        
                        TextField(selectedOption == UnitData.metricOption ? "E.g. 10 L" : "E.g. 10 G", text: $refuelViewModel.fuelInForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(refuelViewModel.isFuelInFormErrorInput ? Color.red : Color.black)
                            .onTapGesture {
                                refuelViewModel.shouldShowDropdown = false
                            }
                            .onChange(of: refuelViewModel.fuelInForm) { newValue in
                                refuelViewModel.validateForm()
                                refuelViewModel.fuelInForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                
                            }
                            .focused($isFuelInFormFocused)
                        
                        if refuelViewModel.isFuelInFormErrorInput {
                            Text(refuelViewModel.fuelInFormErrorMessage)
                                .font(.sfMonoMedium(fontSize: 12.0))
                                .tracking(-1.96)
                                .foregroundColor(.red)
                        }
                    }
                    // CONTENT-END: Fuel In
                    
                    // CONTENT-START: Fuel Cost per Unit
                    Group {
                        Text("Fuel Cost per \(selectedOption == UnitData.metricOption ? "Liter" : "Gallon") (optional)")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField("E.g. 100", text: $refuelViewModel.fuelCostPerUnitForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(.black)
                            .onTapGesture {
                                refuelViewModel.shouldShowDropdown = false
                            }
                            .onChange(of: refuelViewModel.fuelCostPerUnitForm) { newValue in
                                refuelViewModel.fuelCostPerUnitForm = TextFieldUtil.handleDecimalInput(value: newValue)
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
                            refuelViewModel.resetFormData()
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
                        Text("Refuel Calculator")
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
        .navigationDestination(for: FuelEfficiencyRoutingPath.self, destination: { _ in
            FuelEfficiencyScreenView(path: $path, fuelEfficiencyValue: $refuelViewModel.fuelEfficiencyForm, selectedOption: $selectedOption)
        })
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

struct RefuelScreenView_Previews: PreviewProvider {
    struct RefuelScreenPreviewer: View {
        @State private var path = NavigationPath()
        @State private var selectedOption: UnitDropdownOption? = UnitData.metricOption
        @StateObject private var refuelViewModel = RefuelViewModel()
        var body: some View {
            RefuelScreenView(path: $path, selectedOption: $selectedOption)
                .environmentObject(refuelViewModel)
        }
    }
    
    static var previews: some View {
        RefuelScreenPreviewer()
    }
}
