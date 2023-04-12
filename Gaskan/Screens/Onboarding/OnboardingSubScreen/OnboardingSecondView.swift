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
                Text("Save Money on Gas")
                    .font(.sfMonoBold(fontSize: 24.0))
                    .tracking(-1.5)
                    .padding([.bottom], 8.0)
                
                Text("By tracking your vehicle’s mileage, you can optimize your fuel consumption and save money on gas.")
                    .font(.sfMonoMedium(fontSize: 16.0))
                    .tracking(-1)
            }.padding(.horizontal, 48)
        }
    }
}

struct OnboardingSecondView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSecondView()
    }
}
