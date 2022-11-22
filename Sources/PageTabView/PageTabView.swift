//
//  PageTabView.swift
//  PageTabView
//
//  Created by Lova on 2021/8/27.
//

import Combine
import SwiftUI

@available(iOS 14.0.0, *)
public struct PageTabView: View {
    @EnvironmentObject var model: Model

    var titles: [AnyView] = []

    var content: [AnyView] = []

    public init<C1: View, C2: View, V0: View, V1: View>(
        @ViewBuilder titleView: @escaping () -> TupleView<(V0, V1)>,
        @ViewBuilder content: @escaping () -> TupleView<(C1, C2)>
    ) {
        let c = content().value
        self.content = [AnyView(c.0), AnyView(c.1)]

        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1)]
    }

    func setup(_ frame: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            if self.model.width != frame.size.width {
                self.model.width = frame.size.width
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

                ContentView(content: content)
                    .environmentObject(model)
            }
        }
    }
}

@available(iOS 14.0.0, *)
extension PageTabView {
    struct HeadView: View {
        @EnvironmentObject var model: PageTabView.Model

        var titles: [AnyView] = []
        var frame: GeometryProxy

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0 ..< self.titles.count) { index in
                    let title = self.titles[index]
                    if index == 0 {
                        Btn(index: index, view: title, frame: frame)
                            .overlay(HorizontalBarView(), alignment: .bottom)
                    } else {
                        Btn(index: index, view: title, frame: frame)
                    }
                }
            }
            .frame(height: 44)
        }

        struct Btn: View {
            @EnvironmentObject var model: PageTabView.Model

            var index: Int
            var view: AnyView
            var frame: GeometryProxy

            var body: some View {
                Button(action: self.model.onPress(index: index, width: self.frame.size.width)) {
                    view.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }

        struct HorizontalBarView: View {
            @EnvironmentObject var model: PageTabView.Model

            var body: some View {
                Capsule()
                    .foregroundColor(.accentColor)
                    .offset(x: self.model.barOffset)
                    .frame(height: 3)
            }
        }
    }

    struct ContentView: View {
        @EnvironmentObject var model: PageTabView.Model

        var content: [AnyView]

        var body: some View {
            PageScrollView(numberOfPage: self.content.count, offset: self.$model.offset) {
                HStack(spacing: 0) {
                    ForEach(0 ..< content.count) { i in
                        content[i]
                            .frame(maxWidth: .infinity)
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
                    self.model.barOffset = -offsetProxy.minX / CGFloat(content.count)
                }
            }
        }
    }
}

@available(iOS 15.0.0, *)
struct PageTabView_Previews: PreviewProvider {
    @StateObject static var pageModel = PageTabView.Model()

    static var previews: some View {
        PageTabView {
            Text("Page1").foregroundColor(.red)
            Text("Page2").foregroundColor(.green)
        } content: {
            List {
                Text("Page 1")

                Button("Green") {
                    pageModel.scrollTo(page: 1)
                }
                .accentColor(.blue)
            }.edgesIgnoringSafeArea(.bottom)

            VStack {
                Text("Page 1")
                Button("Red") {
                    pageModel.scrollTo(page: 0)
                }
                .accentColor(.blue)
            }
        }
        .environmentObject(pageModel)
        .accentColor(.purple)
        .edgesIgnoringSafeArea(.bottom)
        .overlay(alignment: .bottom) {
            Text("\(pageModel.page)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()
        }
    }
}
