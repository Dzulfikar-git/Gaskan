//
//  OnboardingFirstView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 04/04/23.
//

import SwiftUI

struct OnboardingFirstView: View {
    var body: some View {
        VStack {
            Image("Onboarding-1-Image").padding(.vertical, 48)
            
            VStack(alignment: .leading) {
                Text("Track Your Vehicle's Fuel Efficiency").font(.sfMonoBold(fontSize: 24.0))
                    .tracking(-1.5)
                    .padding([.bottom], 8.0)
                
                Text("Learn how to calculate your vehicle’s mileage based on its remaining fuel and fuel efficiency.")
                    .font(.sfMonoMedium(fontSize: 16.0))
                    .tracking(-1)
            }.padding(.horizontal, 48)
        }
    }
}

struct OnboardingFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirstView()
    }
}
