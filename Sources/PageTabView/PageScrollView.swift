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

    var numberOfPage: Int
    @Binding var offset: CGFloat

    var content: () -> Content

    init(numberOfPage: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.numberOfPage = numberOfPage
        self.content = content
        self._offset = offset
    }

    func makeUIView(context: Context) -> UIViewType {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        let hostView = UIHostingController(rootView: HStack(spacing: 0) {
            content()
        })

        hostView.view.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(hostView.view)
        scrollView.addConstraints([
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            hostView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(self.numberOfPage))
        ])

        scrollView.delegate = context.coordinator

        return scrollView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.isScrollEnabled = true

        let page = round(self.offset / uiView.bounds.size.width)
        if uiView.contentOffset.x != self.offset {
            self.scrollTo(uiView, x: page * uiView.bounds.size.width)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    @State var task: UIViewPropertyAnimator?
    func scrollTo(_ uiView: UIViewType, x: CGFloat) {
        self.task?.stopAnimation(true)

        self.task = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            uiView.contentOffset.x = x
        }
        self.task?.startAnimation()
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

        /// for orientation changed
        func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
            let page = round(self.view.offset / scrollView.bounds.size.width)

            if scrollView.contentOffset.x != self.view.offset {
                self.view.scrollTo(scrollView, x: page * scrollView.bounds.size.width)
            }
        }
    }
}
