//
//  MyDisclosureStyle.swift
//  Gaskan
//
//  Created by Dzulfikar on 03/04/23.
//

import Foundation
import SwiftUI

struct CircleChevronDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                withAnimation {
                    configuration.isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .center) {
                    configuration.label
                    Spacer()
                    Image(systemName: configuration.isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.appPrimaryColor)
                        .frame(width: 30.0)
                        .animation(nil, value: configuration.isExpanded)
                }
            }
            .buttonStyle(.plain)
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}
