//
//  ContentView.swift
//  CoreDataTest
//
//  Created by Muhammad Adha Fajri Jonison on 16/04/23.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling = false
    @State private var isAtBottom = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(1...20, id: \.self) { i in
                    Text("Item \(i)")
                        .frame(height: 100)
                }
            }
            .padding()
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            // Set the initial scroll offset to the current content offset
                            scrollOffset = proxy.frame(in: .global).minY
                            isAtBottom = proxy.frame(in: .global).maxY <= UIScreen.main.bounds.maxY
                        }
                        .onChange(of: proxy.frame(in: .global).minY) { newValue in
                            
                            scrollOffset = newValue
                            
                            let offsetY = max(0, proxy.frame(in: .global).maxY - UIScreen.main.bounds.height)
                            isAtBottom = offsetY == 0.0
                            
                            isScrolling = true
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                isScrolling = false
                            }
                        }
                }
            )
        }
    }
}



private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
