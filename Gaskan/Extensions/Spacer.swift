//
//  Spacer.swift
//  Gaskan
//
//  Created by Dzulfikar on 04/04/23.
//

import Foundation
import SwiftUI

extension Spacer {
    // Override onTapGesture function on Spacer to create a Layout with Transparant color.
    public func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        ZStack {
            Color.black.opacity(0.001).onTapGesture(count: count, perform: action)
            self
        }
    }
}
