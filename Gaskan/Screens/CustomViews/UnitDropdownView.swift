//
//  UnitDropdownView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//
//  Code inspired by user `emmanuelkehinde` on github
//  Link: https://gist.github.com/emmanuelkehinde/ff0af45b9837eb2a925381a709960f9e

import SwiftUI

// This object is used to set data for the dropdown options.
// @param key = `key` as identifier of the data
// @param value = `value` as value of the data
struct UnitDropdownOption: Hashable {
    let key: Int
    let value: String
    
    public static func == (lhs: UnitDropdownOption, rhs: UnitDropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

// This view is used as Row component to display each UnitDropdownOption
// @param option = data of the option
// @param onOptionSelected = closure to return selected UnitDropdownOption
struct UnitDropdownRow: View {
    var option: UnitDropdownOption
    var onOptionSelected: ((_ option: UnitDropdownOption) -> Void)?
    
    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option) // When an option is selected, it will set onOptionSelected to selected UnitDropdownOption
            }
        }) {
            HStack {
                Text(self.option.value)
                    .font(.sfMonoLight(fontSize: 14))
                    .tracking(-1.24)
                    .foregroundColor(.appSecondaryColor)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

// This view is used to show list of UnitDropdownRow
// @param options = Array of UnitDropdownOption to be listed
// @param onOptionSelected = Callback for selected UnitDropdownOption
struct UnitDropdownList: View {
    var options: [UnitDropdownOption]
    var onOptionSelected: ((_ option: UnitDropdownOption) -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in // Loop each options and show UnitDropdownRow
                    UnitDropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250)
        .padding(.vertical, 5)
        .background(Color.appPrimaryColor)
        .overlay(
            Rectangle().stroke(Color.black, lineWidth: 1)
        )
    }
    
}

// This view is the parent of the UnitDropdown component
// @param placeholder = Initial option text to shown
// @param options = List of UnitDropdownOption data
// @param onOptionsSelected = closure for selected unit dropdown option
struct UnitDropdownView: View {
    @Binding var shouldShowDropdown: Bool
    @Binding var selectedOption: UnitDropdownOption?
    var placeholder: String
    var options: [UnitDropdownOption]
    var onOptionSelected: ((_ option: UnitDropdownOption) -> Void)?
    var isExpandingState: ((_ state: Bool) -> Void)
    
    private let buttonHeight: CGFloat = 48
    
    var body: some View {
        Button(action: {
            self.shouldShowDropdown.toggle()
            isExpandingState(self.shouldShowDropdown)
        }) {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.value)
                    .font(.sfMonoLight(fontSize: 14))
                    .tracking(-1.24)
                    .foregroundColor(selectedOption == nil ? Color.appTertiaryColor: Color.black)
                
                Spacer()
                
                Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(Color.black)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, minHeight: self.buttonHeight, maxHeight: self.buttonHeight)
        .overlay(
            Rectangle().stroke(Color.black, lineWidth: 1)
        )
        .overlay(
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: buttonHeight + 10)
                    UnitDropdownList(options: self.options, onOptionSelected: { option in
                        shouldShowDropdown = false
                        selectedOption = option
                        self.onOptionSelected?(option)
                    })
                }
            }, alignment: .topLeading
        )
        .background(
            RoundedRectangle(cornerRadius: 5).fill(Color.appPrimaryColor)
        )
        .padding(.bottom, self.shouldShowDropdown ? CGFloat(self.options.count * 32) > 300 ? 300 + 16 : CGFloat(self.options.count * 32) + 16 : 0)
    }
}

struct UnitDropdownView_Previews: PreviewProvider {
    struct UnitDropdownViewPreviewer: View {
        @State var shouldShowDropdown = false
        @State var selectedOption: UnitDropdownOption? = UnitDropdownOption(key: 0, value: "Metric")
        
        var uniqueKey: String {
            UUID().uuidString
        }
        
        let options: [UnitDropdownOption] = [
            UnitDropdownOption(key: 0, value: "Metric"),
            UnitDropdownOption(key: 1, value: "US"),
        ]
        
        var body: some View {
            VStack {
                Group {
                    UnitDropdownView(
                        shouldShowDropdown: $shouldShowDropdown,
                        selectedOption: $selectedOption, placeholder: "Unit",
                        options: options,
                        onOptionSelected: { option in
//                            print(option)
                        },
                        isExpandingState: { state in
//                            print(state)
                        }
                    )
                    
                }
            }
        }
    }
    
    static var previews: some View {
        UnitDropdownViewPreviewer()
    }
}
