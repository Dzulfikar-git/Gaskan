//
//  ViewModifier.swift
//  Gaskan
//
//  Created by Muhammad Adha Fajri Jonison on 15/04/23.
//

import UIKit
import SwiftUI

struct CustomScrollView<Content: View>: UIViewRepresentable {
    let onScrollBegin: () -> Void
    let onScrollEnd: () -> Void
    let onReachedEnd: () -> Void
    var content: Content

    func makeCoordinator() -> Coordinator {
        Coordinator(onScrollBegin: onScrollBegin, onScrollEnd: onScrollEnd, onReachedEnd: onReachedEnd)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsVerticalScrollIndicator = false
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {}

    class Coordinator: NSObject, UIScrollViewDelegate {
        let onScrollBegin: () -> Void
        let onScrollEnd: () -> Void
        let onReachedEnd: () -> Void

        init(onScrollBegin: @escaping () -> Void, onScrollEnd: @escaping () -> Void, onReachedEnd: @escaping () -> Void) {
            self.onScrollBegin = onScrollBegin
            self.onScrollEnd = onScrollEnd
            self.onReachedEnd = onReachedEnd
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            onScrollBegin()
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                onScrollEnd()
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            onScrollEnd()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let currentOffset = scrollView.contentOffset.y

            let bottomBounce = currentOffset > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom

            if bottomBounce {
                onReachedEnd()
            }
        }
    }
}

