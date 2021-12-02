//
//  PageTabView.swift
//  PageTabView
//
//  Created by Lova on 2021/8/27.
//

import Combine
import SwiftUI

public
struct PageTabView<Content: View>: View {
    @ObservedObject var model = Model()

    let titles: [AnyView]
    let content: () -> Content

    public
    init<V0: View, V1: View>(@ViewBuilder titleView: @escaping () -> TupleView<(V0, V1)>, @ViewBuilder content: @escaping () -> Content) {
        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1)]
        self.content = content
    }

    public
    init<V0: View, V1: View, V2: View>(@ViewBuilder titleView: @escaping () -> TupleView<(V0, V1, V2)>, @ViewBuilder content: @escaping () -> Content) {
        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2)]
        self.content = content
    }

    public
    init<V0: View, V1: View, V2: View, V3: View>(@ViewBuilder titleView: @escaping () -> TupleView<(V0, V1, V2, V3)>, @ViewBuilder content: @escaping () -> Content) {
        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3)]
        self.content = content
    }

    public
    init<V0: View, V1: View, V2: View, V3: View, V4: View>(@ViewBuilder titleView: @escaping () -> TupleView<(V0, V1, V2, V3, V4)>, @ViewBuilder content: @escaping () -> Content) {
        let cv = titleView().value
        self.titles = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4)]
        self.content = content
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
            .onPreferenceChange(TabPreferenceKey.self) { rect in
                self.model.numberOfPage = frame.size.width / rect.width
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
        PageScrollView(offset: $model.offset) {
            self.content()
                .frame(width: proxy.size.width)
                // Subscribe ScrollView ContentOffset
                .overlay(
                    GeometryReader { offsetProxy in
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offsetProxy.frame(in: .global))
                    }
                )
                // Then Set Offset
                .onPreferenceChange(TabPreferenceKey.self) { offsetProxy in
                    self.model.barOffset = -offsetProxy.minX / model.numberOfPage
                }
        }
        // Observe Orientation
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { output in
            print(output)
//            if let int = output.userInfo?["UIDeviceOrientationRotateAnimatedUserInfoKey"] as? Int, let orientation = UIDeviceOrientation(rawValue: int) {
//                self.orientation = orientation
//            }
        }
    }
}

extension PageTabView {
    class Model: ObservableObject {
        @Published var barOffset: CGFloat = 0
        @Published var numberOfPage: CGFloat = 0
        @Published var offset: CGFloat = 0

        func onPress(index: Int, width: CGFloat) -> () -> Void {
            return {
                let offset = CGFloat(index) * width
                if self.offset != offset {
                    self.offset = offset
                }
            }
        }
    }
}

struct PageTabView_Previews: PreviewProvider {
    struct ExtractedView: View {
        var body: some View {
            PageTabView {
                Text("red").foregroundColor(.red)
                Text("green").foregroundColor(.green)
                Text("blue").foregroundColor(.blue)
                Text("yellow").foregroundColor(.yellow)
            } content: {
                Color.red

                Color.green

                Color.blue

                Color.yellow
            }
            .accentColor(.green)
        }
    }

    static var previews: some View {
        ExtractedView()
    }
}
