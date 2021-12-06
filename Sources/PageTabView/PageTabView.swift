//
//  PageTabView.swift
//  PageTabView
//
//  Created by Lova on 2021/8/27.
//

import Combine
import SwiftUI

@available(iOS 13.0.0, *)
public
struct PageTabView<Content: View>: View {
    @ObservedObject var model = Model()

    var titles: [AnyView] = []
    let content: (Model) -> Content

    public
    init<V0: View, V1: View>(
        @ViewBuilder titleView: @escaping (Binding<Int>) -> TupleView<(V0, V1)>,
        @ViewBuilder content: @escaping (Model) -> Content
    ) {
        self.content = content
        let cv = titleView($model.page).value
        self.titles = [AnyView(cv.0), AnyView(cv.1)]
    }

    public var body: some View {
        GeometryReader { frame in
            VStack(spacing: 0) {
                Head(frame)

                ContentBody(frame)
            }
        }
    }

    private func Head(_ frame: GeometryProxy) -> some View {
        func Btn(_ index: Int) -> some View {
            Button(action: self.model.onPress(index: index, width: frame.size.width)) {
                self.titles[index]
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
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

        return HStack(spacing: 0) {
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

    private func ContentBody(_ proxy: GeometryProxy) -> some View {
        PageScrollView(numberOfPage: self.titles.count, offset: self.$model.offset) {
            self.content(self.model)
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

@available(iOS 13.0.0, *)
struct PageTabView_Previews: PreviewProvider {
    struct ExtractedView: View {
        var body: some View {
            PageTabView { _ in
                Text("red").foregroundColor(.red)
                Text("green").foregroundColor(.green)
            } content: { model in
                VStack {
                    Button("red") {
                        model.scrollTo(page: 1)
                    }
                }

                VStack {
                    Button("green") {
                        model.scrollTo(page: 0)
                    }
                }
            }
            .accentColor(.black)
        }
    }

    static var previews: some View {
        ExtractedView()
    }
}
