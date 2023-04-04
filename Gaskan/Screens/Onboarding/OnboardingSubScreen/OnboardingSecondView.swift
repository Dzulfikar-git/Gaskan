//
//  OnboardingSecondView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 04/04/23.
//

import SwiftUI

struct OnboardingSecondView: View {
    var body: some View {
        VStack {
            Image("Onboarding-2-Image").padding(.vertical, 48)
            
            VStack(alignment: .leading) {
                Text("Save Money on Gas").font(.system(size: 24)).fontWeight(.bold).padding(.vertical, 8)
                
                Text("By tracking your vehicle’s mileage, you can optimize your fuel consumption and save money on gas.").padding(.vertical,8)
            }.padding(.horizontal, 48)
        }
    }
}

struct OnboardingSecondView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSecondView()
    }
}
