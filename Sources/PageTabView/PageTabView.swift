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

    @State var titles: [AnyView] = [AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text("")), AnyView(Text(""))]
    var content: [AnyView] = []

    public init<C0: View>(@ViewBuilder content: @escaping () -> TupleView<C0>) {
        let c = content().value
        self.content = [AnyView(c)]
    }

    public init<C0: View, C1: View>(@ViewBuilder content: @escaping () -> TupleView<(C0, C1)>) {
        let c = content().value
        self.content = [AnyView(c.0), AnyView(c.1)]
    }

    public init<C0: View, C1: View, C2: View>(@ViewBuilder content: @escaping () -> TupleView<(C0, C1, C2)>) {
        let c = content().value
        self.content = [AnyView(c.0), AnyView(c.1), AnyView(c.2)]
    }

    public init<C0: View, C1: View, C2: View, C3: View>(@ViewBuilder content: @escaping () -> TupleView<(C0, C1, C2, C3)>) {
        let c = content().value
        self.content = [AnyView(c.0), AnyView(c.1), AnyView(c.2), AnyView(c.3)]
    }

    public init<C0: View, C1: View, C2: View, C3: View, C4: View>(@ViewBuilder content: @escaping () -> TupleView<(C0, C1, C2, C3, C4)>) {
        let c = content().value
        self.content = [AnyView(c.0), AnyView(c.1), AnyView(c.2), AnyView(c.3), AnyView(c.4)]
    }
}

@available(iOS 14.0.0, *)
public extension PageTabView {
    var body: some View {
        GeometryReader { frame in
            VStack(spacing: 0) {
                setup(frame)

                HeadView(count: self.content.count, titles: $titles, frame: frame)

                PageScrollView(numberOfPage: self.content.count, offset: self.$model.offset) {
                    ForEach(content.identified()) { item in
                        let index = item.index
                        let content = item.value

                        content
                            .onPreferenceChange(TitleViewPreferenceKey.self) { v in
                                self.titles[index] = AnyView(v.value)
                            }
                            .frame(maxWidth: .infinity)
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
}

@available(iOS 14.0.0, *)
extension PageTabView {
    private func setup(_ frame: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            if self.model.width != frame.size.width {
                self.model.width = frame.size.width
            }
        }

        return EmptyView()
    }

    struct HeadView: View {
        @EnvironmentObject var model: PageTabView.Model

        var count = 0
        var titles: Binding<[AnyView]>
        var frame: GeometryProxy

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0 ..< count) { index in
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
            var view: Binding<AnyView>
            var frame: GeometryProxy

            var body: some View {
                Button(action: { self.model.scrollTo(page: index) }) {
                    view
                        .wrappedValue
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }

        struct HorizontalBarView: View {
            @EnvironmentObject var model: PageTabView.Model

            var body: some View {
                Capsule()
                    .foregroundColor(.accentColor)
                    .animation(.easeOut(duration: 0.1), value: self.model.barOffset)
                    .offset(x: self.model.barOffset)
                    .frame(height: 3)
            }
        }
    }
}

@available(iOS 15.0.0, *)
struct PageTabView_Previews: PreviewProvider {
    @StateObject static var pageModel = PageTabView.Model()

    static var previews: some View {
        PageTabView {
            List {
                Text("Page 1")

                Button("Green") {
                    pageModel.scrollTo(page: 1)
                }
                .accentColor(.green)
            }
            .edgesIgnoringSafeArea(.bottom)
            .pageTitleView {
                Text("Page1").foregroundColor(.red)
            }

            VStack {
                Text("Page 2")
                Button("Red") {
                    pageModel.scrollTo(page: 0)
                }
                .accentColor(.red)
            }
            .pageTitleView {
                Text("Page2")
                    .foregroundColor(.green)
                    .overlay(Color.red.frame(width: 4, height: 4), alignment: .topTrailing)
            }
        }
        .environmentObject(pageModel)
        .accentColor(.purple)
        .edgesIgnoringSafeArea(.bottom)
        .overlay(alignment: .bottom) {
            Text("\(pageModel.page)")
                .frame(maxWidth: .infinity)
                .padding()
                .background(.yellow)
                .foregroundColor(.black)
                .font(.title.bold())
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()
                .shadow(radius: 8)
        }
    }
}
