//
//  PageTabView.swift
//  PageTabView
//
//  Created by Lova on 2021/8/27.
//

import Combine
import SwiftUI

@available(iOS 14.0.0, *)
public
struct PageTabView: View {
    @StateObject var model = Model()

    @Environment(\.onPageUpdate) var onPageUpdate: (Int) -> Void

    var titles: [AnyView] = []

    let content: [AnyView]

    public init<C1: View, C2: View, V0: View, V1: View>(
        @ViewBuilder titleView: @escaping () -> TupleView<(V0, V1)>,
        @ViewBuilder content: @escaping () -> TupleView<(C1, C2)>
    ) {
        let c = content().value
        self.content = [AnyView(c.0), AnyView(c.1)]

        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1)]
        self.model.onPageUpdate = self.onPageUpdate
    }

    func setup(_ frame: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            if model.width != frame.size.width {
                model.width = frame.size.width
            }
            self.model.onPageUpdate = { [self] int in
                self.onPageUpdate(int)
            }
        }

        return EmptyView()
    }

    public var body: some View {
        GeometryReader { frame in
            VStack(spacing: 0) {
                setup(frame)

                HeadView(titles: titles, frame: frame)
                    .environmentObject(model)

                ContentView(titles: titles, frame: frame, content: content)
                    .environmentObject(model)
            }
        }
    }
}

@available(iOS 14.0.0, *)
extension PageTabView {
    struct HeadView: View {
        var titles: [AnyView] = []
        var frame: GeometryProxy
        @EnvironmentObject var model: PageTabView.Model

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0 ..< self.titles.count) { index in
                    if index == 0 {
                        Btn(index)
                            .overlay(HorizontalBar(), alignment: .bottom)
                    } else {
                        Btn(index)
                    }
                }
            }
            .frame(height: 44)
        }

        func HorizontalBar() -> some View {
            GeometryReader { proxy in
                Capsule()
                    .foregroundColor(.accentColor)
                    // Subscribe Bar Width
                    .preference(key: TabPreferenceKey.self, value: proxy.frame(in: .local))
            }
            .offset(x: self.model.barOffset)
            .frame(height: 3)
            // Use Bar Width to calculate Button counts
        }

        func Btn(_ index: Int) -> some View {
            Button(action: self.model.onPress(index: index, width: self.frame.size.width)) {
                self.titles[index]
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    struct ContentView: View {
        var titles: [AnyView] = []
        var frame: GeometryProxy
        @EnvironmentObject var model: PageTabView.Model

        var content: [AnyView]

        var body: some View {
            PageScrollView(numberOfPage: self.titles.count, offset: self.$model.offset) {
                HStack(spacing: 0) {
                    ForEach(0 ..< content.count) { i in
                        content[i]
                    }
                }
                // Subscribe ScrollView ContentOffset
                .overlay(
                    GeometryReader { offsetProxy in
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offsetProxy.frame(in: .global))
                    }
                )
                // Then Set Offset
                .onPreferenceChange(TabPreferenceKey.self) { offsetProxy in
                    self.model.barOffset = -offsetProxy.minX / CGFloat(titles.count)
                }
            }
        }
    }
}

@available(iOS 14.0.0, *)
struct PageTabView_Previews: PreviewProvider {
    static var previews: some View {
        PageTabView {
            Text("red").foregroundColor(.red)
            Text("green").foregroundColor(.green)
        } content: {
            VStack {
                Button("red") {
//                    scrollTo(1)
                }
            }
            .frame(maxWidth: .infinity)

            VStack {
                Button("green") {
//                    scrollTo(0)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .accentColor(.black)
    }
}
