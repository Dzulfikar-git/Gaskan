//
//  RefuelScreenView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 16/04/23.
//

import SwiftUI

struct RefuelScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var path: NavigationPath
    
    // STATE START: dropdown state
    @State private var shouldShowDropdown = false
    @State private var isDropdownExpanding = false
    // STATE END: dropdown state
    
    // STATE START: unit selection state
    @Binding var selectedOption: UnitDropdownOption?
    // STATE END: unit selection state
    
    // STATE START: fuel efficiency form state
    @State private var fuelEfficiencyForm: String = ""
    @State private var isFuelEfficiencyFormErrorInput: Bool = false
    @State private var fuelEfficiencyFormErrorMessage: String = ""
    @FocusState private var isFuelEfficiencyFocused: Bool
    // STATE END: fuel efficiency form state
    
    // STATE START: fuel in form state
    @State private var fuelInForm: String = ""
    @State private var isFuelInFormErrorInput: Bool = false
    @State private var fuelInFormErrorMessage: String = ""
    @FocusState private var isFuelInFormFocused: Bool
    // STATE END: fuel in form state
    
    // STATE START: fuel cost per unit form state
    @State private var fuelCostPerUnitForm: String = ""
    @FocusState private var isFuelCostPerUnitFocused: Bool
    // STATE START: fuel cost per unit form state
    
    // STATE START: finding fuel efficiency state
    @State private var isFindingFuelEfficiency: Bool = false
    
    // STATE START: calculate button pressed state
    @State private var isCalculateButtonPressed: Bool = false
    // STATE END: calculate button pressed state
    
    // STATE START: total mileage value state
    @State private var totalMileage: Double = 0
    // STATE END: total mileage value state
    
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
        if fuelEfficiencyForm.isEmpty {
            handleEmptyFormValidation(formInputErrorState: self.$isFuelEfficiencyFormErrorInput, formInputErrorMessageState: self.$fuelEfficiencyFormErrorMessage, errorState: true)
        }
        
        if fuelInForm.isEmpty {
            handleEmptyFormValidation(formInputErrorState: self.$isFuelInFormErrorInput, formInputErrorMessageState: self.$fuelInFormErrorMessage, errorState: true)
        }
        
        if !fuelEfficiencyForm.isEmpty && !fuelInForm.isEmpty {
            totalMileage = ((Double(fuelEfficiencyForm) ?? 0) * (Double(fuelInForm) ?? 0)).rounded(.toNearestOrAwayFromZero)
            isCalculateButtonPressed = true
            addItem()
            path.removeLast(path.count)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.type = CalculationType.refuel.rawValue
            newItem.timestamp = Date()
            newItem.totalMileage = Float(totalMileage)
            newItem.fuelEfficiency = Float(fuelEfficiencyForm) ?? 0.0
            newItem.totalFuelCost = (Float(fuelInForm) ?? 0.0) * (Float(fuelCostPerUnitForm) ?? 0.0)
            newItem.unit = selectedOption?.value

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
    
    // function for resetting form values.
    // it will set the value of all form to be `""` equals to empty string
    private func handleResetData() {
        fuelEfficiencyForm = ""
        fuelInForm = ""
        fuelCostPerUnitForm = ""
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
                        
                        TextField(selectedOption == UnitData.metricOption ? "E.g. 10 KM/L" : "E.g. 10 M/G", text: $fuelEfficiencyForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(isFuelEfficiencyFormErrorInput ? Color.red : Color.black)
                            .onTapGesture {
                                shouldShowDropdown = false
                            }
                            .onChange(of: fuelEfficiencyForm) { newValue in
                                handleEmptyFormValidation(formInputErrorState: self.$isFuelEfficiencyFormErrorInput, formInputErrorMessageState: self.$fuelEfficiencyFormErrorMessage, errorState: newValue.isEmpty)
                                fuelEfficiencyForm = TextFieldUtil.handleDecimalInput(value: newValue)
                            }
                            .focused($isFuelEfficiencyFocused)
                        
                        if isFuelEfficiencyFormErrorInput {
                            Text(fuelEfficiencyFormErrorMessage)
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
                        Text("Fuel In")
                            .font(.sfMonoRegular(fontSize: 15))
                            .tracking(-1.32)
                            .foregroundColor(.appTertiaryColor)
                            .padding([.top], 8.0)
                        
                        TextField(selectedOption == UnitData.metricOption ? "E.g. 10 L" : "E.g. 10 G", text: $fuelInForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(isFuelInFormErrorInput ? Color.red : Color.black)
                            .onTapGesture {
                                shouldShowDropdown = false
                            }
                            .onChange(of: fuelInForm) { newValue in
                                handleEmptyFormValidation(formInputErrorState: self.$isFuelInFormErrorInput, formInputErrorMessageState: self.$fuelInFormErrorMessage, errorState: newValue.isEmpty)
                                fuelInForm = TextFieldUtil.handleDecimalInput(value: newValue)
                                
                            }
                            .focused($isFuelInFormFocused)
                        
                        if isFuelInFormErrorInput {
                            Text(fuelInFormErrorMessage)
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
                        
                        TextField("E.g. 100", text: $fuelCostPerUnitForm)
                            .font(.sfMonoLight(fontSize: 14.0))
                            .tracking(-1.24)
                            .keyboardType(.decimalPad)
                            .padding(12.0)
                            .border(.black)
                            .onTapGesture {
                                shouldShowDropdown = false
                            }
                            .onChange(of: fuelCostPerUnitForm) { newValue in
                                fuelCostPerUnitForm = TextFieldUtil.handleDecimalInput(value: newValue)
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
                            handleResetData()
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
            FuelEfficiencyScreenView(path: $path, fuelEfficiencyValue: $fuelEfficiencyForm, selectedOption: $selectedOption)
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
        var body: some View {
            RefuelScreenView(path: $path, selectedOption: $selectedOption)
        }
    }
    
    static var previews: some View {
        RefuelScreenPreviewer()
    }
}
