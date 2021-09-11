//
//  OffsetTabView.swift
//  OffsetTabView
//
//  Created by Lova on 2021/8/27.
//

import SwiftUI

struct OffsetTabView<Content: View>: UIViewRepresentable {
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

        return scrollView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct OffsetTabView_Previews: PreviewProvider {
    static var previews: some View {
        OffsetTabView(offset: .constant(0)) {
            Text("1")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)

            Text("2")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)

            Text("3")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
        }
    }
}
