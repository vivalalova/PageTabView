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

    let titles: [AnyView]
    let content: (Model) -> Content

    public
    init<V0: View, V1: View>(
        @ViewBuilder titleView: @escaping () -> TupleView<(V0, V1)>,
        @ViewBuilder content: @escaping (Model) -> Content
    ) {
        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1)]
        self.content = content
    }

    public var body: some View {
        GeometryReader { frame in
            VStack(spacing: 0) {
                Head(frame)

                ContentBody(frame)
            }.onAppear {
                self.model.width = frame.size.width
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
            .onPreferenceChange(TabPreferenceKey.self) { rect in
                let number = frame.size.width / rect.width
                if !(number.isNaN || number.isInfinite) {
                    self.model.numberOfPage = Int(number)
                }
            }
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
        PageScrollView(offset: self.$model.offset) {
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
                    self.model.barOffset = -offsetProxy.minX / CGFloat(model.numberOfPage)
                }
        }
    }
}

@available(iOS 13.0.0, *)
struct PageTabView_Previews: PreviewProvider {
    struct ExtractedView: View {
        var body: some View {
            PageTabView {
                Text("red").foregroundColor(.red)
                Text("green").foregroundColor(.green)
            } content: { model in
                VStack {
                    Button("red") {
                        model.page = 1
                    }
                }

                VStack {
                    Button("green") {
                        model.page = 0
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
