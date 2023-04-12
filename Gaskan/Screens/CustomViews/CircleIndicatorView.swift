//
//  CircleIndicatorView.swift
//  Gaskan
//
//  Created by Dzulfikar on 10/04/23.
//

import SwiftUI

struct CircleIndicatorView: View {
    var tag: Int
    @Binding var selectedTag: Int
    var body: some View {
        if tag == selectedTag {
            Circle()
                .shadow(color: .pageIndexViewIndicatorColor, radius: 5.0)
                .frame(width: 8.0)
                .foregroundColor(.pageIndexViewIndicatorColor)
        } else {
            Circle()
                .frame(width: 8.0)
                .foregroundColor(.pageIndexViewIndicatorColor)
        }
    }
}

struct CircleIndicatorView_Previews: PreviewProvider {
    struct CircleIndicatorViewPreviewer: View {
        var tag: Int = 0
        @State private var selectedTag: Int = 0
        var body: some View {
            CircleIndicatorView(tag: tag, selectedTag: $selectedTag)
        }
    }
    
    static var previews: some View {
        CircleIndicatorViewPreviewer()
    }
}
