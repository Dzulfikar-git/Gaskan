//
//  ChildCardView.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 12/04/23.
//

import SwiftUI

struct ChildCardView: View {
    var title = ""
    var value = ""
    var unit = ""
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.sfMonoBold(fontSize: 14))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                
                Text(value + " " + unit)
                    .font(.sfMonoBold(fontSize: 14))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .padding(16.0)
            .background(Color.appSecondaryColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(8.0)
        .border(Color.appSecondaryColor, width: 2.0)
        .padding([.bottom], 16.0)
    }
}

struct ChildCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChildCardView()
    }
}
