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
            Image("Onboarding-3-Image").padding(.vertical, 48)
            
            VStack(alignment: .leading) {
                Text("Prevent Breakdowns").font(.sfMonoBold(fontSize: 24.0))
                    .tracking(-1.5)
                    .padding([.bottom], 8.0)
                
                Text("Minimize the possibility of your personal vehicle to breakdown.")
                    .font(.sfMonoMedium(fontSize: 16.0))
                    .tracking(-1)
            }.padding(.horizontal, 48)
        }
    }
}

struct OnboardingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingThirdView()
    }
}
