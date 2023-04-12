//
//  OnboardingView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 04/04/23.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedTabIndex = 0
    
    var onFinish: (Bool) -> Void
    
    private func indicatorCircle(for index: Int) -> some View {
        Circle()
            .foregroundColor(selectedTabIndex == index ? Color.yellow : Color.gray)
            .shadow(color: selectedTabIndex == index ? .yellow : .clear, radius: 5, x: 0, y: 0)
            .frame(width: 8)
    }
    
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
                ForEach(0..<3, id: \.self) { index in
                    CircleIndicatorView(tag: index, selectedTag: $selectedTabIndex)
                }
                
                Spacer()
                
                if selectedTabIndex == 2 { // Reached the last onboarding view
                    Button("START") {
                        onFinish(true)
                    }
                    .font(.sfMonoBold(fontSize: 16.0))
                    .tracking(0.8)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color("AppSecondary"))
                } else {
                    Button(action: {
                        withAnimation {
                            selectedTabIndex += 1
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.body)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: 50, height: 50)
                    }.background(Color("AppSecondary"))
                        .clipShape(Circle())
                }
                
            }.padding(.horizontal, 48)
            
            Spacer()
                .padding(24)
                .fixedSize()
            
        }.background(Image("BackgroundNoise").resizable()
            .aspectRatio(contentMode: .fill)
            .blendMode(.multiply)
            .opacity(0.05) // adjust the opacity of the noise texture
            .ignoresSafeArea()) // Noise Image
        .background(Image("BackgroundPath-2").offset(y: -100)) // Path Image
        .background(Image("BackgroundGradient-2").offset(y: -100)) // Gradient Image
        .background(Color("AppPrimary")) // Background Color
        .ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onFinish: { value in print(value) })
    }
}
