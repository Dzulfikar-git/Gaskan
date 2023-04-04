//
//  OnboardingThirdView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 04/04/23.
//

import SwiftUI

struct OnboardingThirdView: View {
    var body: some View {
        VStack {
            Image("Scooter").padding(.vertical, 48)
            
            VStack(alignment: .leading) {
                Text("Prevent Breakdowns").font(.system(size: 24)).fontWeight(.bold).padding(.vertical, 8)
                
                Text("Minimize the possibility of your personal vehicle to breakdown.").padding(.vertical,8)
            }.padding(.horizontal, 48)
        }
    }
}

struct OnboardingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingThirdView()
    }
}
