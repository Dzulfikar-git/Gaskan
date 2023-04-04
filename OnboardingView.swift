//
//  OnboardingView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 04/04/23.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedTabIndex = 0
    
    var body: some View {
        VStack {
                TabView(selection: $selectedTabIndex) {
                    OnboardingFirstView().tag(0)
                    
                    OnboardingSecondView().tag(1)
                    
                    OnboardingThirdView().tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: selectedTabIndex)
                .transition(.slide)
                
                HStack {
                    Circle().foregroundColor(selectedTabIndex == 0 ? Color.yellow : Color.gray).shadow(color: selectedTabIndex == 0 ? .yellow : .clear, radius: 5, x: 0, y: 0).frame(width: 8)
                    
                    Circle().foregroundColor(selectedTabIndex == 1 ? Color.yellow : Color.gray).shadow(color: selectedTabIndex == 1 ? .yellow : .clear, radius: 5, x: 0, y: 0).frame(width: 8)
                    
                    Circle().foregroundColor(selectedTabIndex == 2 ? Color.yellow : Color.gray).shadow(color: selectedTabIndex == 2 ? .yellow : .clear, radius: 5, x: 0, y: 0).frame(width: 8)
                    
                    Spacer()
                    
                    if selectedTabIndex == 2 {
                        Button("START") {
                            
                        }.frame(width: 100, height: 50).foregroundColor(.white).background(Color("DarkColor"))
                    } else {
                        Button(action: {
                            withAnimation {
                                selectedTabIndex += 1
                            }
                        }) {
                            Image(systemName: "chevron.right").font(.body).foregroundColor(.white).frame(width: 50, height: 50)
                        }.background(Color("DarkColor")).clipShape(Circle())
                    }
                    
                }.padding(.horizontal, 48)
            
            Spacer().padding(16).fixedSize()
            
        }.background(Image("Noise")) // Noise Image
        .background(Image("Path-2").offset(y: -100)) // Path Image
            .background(Image("Gradient-onboard").offset(y: -100)) // Gradient Image
            .background(Color("BackgroundColor")) // Background Color
            .ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
