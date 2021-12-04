//
//  OffsetTabView.swift
//  OffsetTabView
//
//  Created by Lova on 2021/8/27.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct PageScrollView<Content: View>: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<PageScrollView>

    typealias UIViewType = UIScrollView

    @Binding var offset: CGFloat

    var content: () -> Content

    init(offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._offset = offset
    }

    func makeUIView(context: Context) -> UIViewType {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        let root = HStack(spacing: 0) {
            content()
        }

        let hostView = UIHostingController(rootView: root)

        hostView.view.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(hostView.view)
        scrollView.addConstraints([
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        scrollView.delegate = context.coordinator

        return scrollView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.isScrollEnabled = true

        if uiView.contentOffset.x != self.offset {
            self.scrollTo(uiView, x: self.offset)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func scrollTo(_ uiView: UIViewType, x: CGFloat) {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            uiView.contentOffset.x = x
        }.startAnimation()
    }
}

@available(iOS 13.0.0, *)
extension PageScrollView {
    class Coordinator: NSObject, UIScrollViewDelegate {
        let view: PageScrollView
        init(_ scrollView: PageScrollView) {
            self.view = scrollView
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if self.view.offset != scrollView.contentOffset.x {
                self.view.offset = scrollView.contentOffset.x
            }
        }
    }
}
