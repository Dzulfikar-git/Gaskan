//
//  DistanceSegmentedControlView.swift
//  Gaskan
//
//  Created by Dzulfikar on 01/04/23.
//

import SwiftUI

struct DistanceSegmentedControlView: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let isSelected = preselectedIndex == index
                ZStack {
                    Rectangle().fill(Color.appPrimaryColor)
                    
                    Rectangle()
                        .padding(3)
                        .opacity(isSelected ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.1,
                                                             dampingFraction: 1,
                                                             blendDuration: 0.1)) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .font(.sfMonoBold(fontSize: 16.0))
                        .foregroundColor(isSelected ? .white : .black) // change else color
                        .tracking(0.8)
                )
            }
        }
        .frame(minHeight: 48.0, maxHeight: 48.0)
        .border(.black, width: 2.0)
    }
}

struct DistanceSegmentedControlView_Previews: PreviewProvider {
    struct DistanceSegmentedControlPreviewer: View {
        @State var selectedIndex: Int = 1
        
        var body: some View {
            DistanceSegmentedControlView(preselectedIndex: $selectedIndex, options: ["DISTANCE", "ODOMETER"])
        }
    }
    
    static var previews: some View {
        DistanceSegmentedControlPreviewer()
    }
}
