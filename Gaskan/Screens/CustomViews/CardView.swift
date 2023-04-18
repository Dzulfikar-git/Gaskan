//
//  CardView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 12/04/23.
//

import SwiftUI

struct CardView: View {
    var title = ""
    var description = ""
    var value = ""
    var unit = ""
    
    var isShowButton = false
    let onClickedPlus: () -> Void
    let onClickedMinus: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.sfMonoBold(fontSize: 16))
                        .tracking(0.8)
                    
                    Text(description)
                        .font(.sfMonoRegular(fontSize: 12))
                        .tracking(-0.38)
                }
                
                Spacer(minLength: 16)
                
                VStack(alignment: .trailing) {
                    Text(value)
                        .font(.sfMonoBold(fontSize: 28))
                        .tracking(1.4)
                    + Text(unit)
                        .font(.sfMonoRegular(fontSize: 14))
                        .tracking(0.7)
                    
                    if isShowButton {
                        HStack {
                            Button {
                                onClickedPlus()
                            } label: {
                                Image(systemName: "plus.square")
                            }
                            
                            Button {
                                onClickedMinus()
                            } label: {
                                Image(systemName: "minus.square")
                            }
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding(16.0)
            .background(Color.appSecondaryColor)
        }
        .padding(8.0)
        .border(Color.appSecondaryColor, width: 2.0)
        .padding([.bottom], 16.0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(onClickedPlus: {}, onClickedMinus: {})
    }
}
