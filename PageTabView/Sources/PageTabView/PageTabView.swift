//
//  PageTabView.swift
//  PageTabView
//
//  Created by Lova on 2021/8/27.
//

import SwiftUI

public
struct PageTabView<Content: View>: View {
    @State var titles: [String]
    let content: () -> Content

    @State private var offset: CGFloat = 0

    public
    init(titles: [String], @ViewBuilder content: @escaping () -> Content) {
        self.titles = titles
        self.content = content
    }

    @State var barOffset: CGFloat = 0
    @State var numberOfPage: CGFloat = 0

    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                self.head(proxy)

                self.contentBody(proxy)
            }
        }
    }

    private func head(_ proxy: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Button {
                let offset: CGFloat = 0
                if self.offset != offset {
                    self.offset = offset
                }
            } label: {
                Text(titles.first ?? "")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.overlay(alignment: .bottom) {
                GeometryReader { proxy in
                    Capsule()
                        .foregroundColor(.accentColor)
                        .preference(key: TabPreferenceKey.self, value: proxy.frame(in: .local))
                }
                .offset(x: barOffset)
                .frame(height: 3)
                .onPreferenceChange(TabPreferenceKey.self) { rect in
                    self.numberOfPage = proxy.size.width / rect.width
                }
            }

            ForEach(1 ..< self.titles.count) { i in
                Button {
                    let offset = CGFloat(i * 375)
                    if self.offset != offset {
                        self.offset = offset
                    }
                } label: {
                    Text(self.titles[i])
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(height: 44)
    }

    private func contentBody(_ proxy: GeometryProxy) -> some View {
        PageScrollView(offset: $offset) {
            self.content()
                .frame(width: proxy.size.width)
                // subscribe offset
                .overlay {
                    GeometryReader { offsetProxy in
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offsetProxy.frame(in: .global))
                    }
                }
                // get offset
                .onPreferenceChange(TabPreferenceKey.self) { offsetProxy in
                    self.barOffset = -offsetProxy.minX / numberOfPage
                }
        }
        // observe orientation
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { output in
            print(output)
        }
    }
}

struct PageTabView_Previews: PreviewProvider {
    static var previews: some View {
        PageTabView(titles: ["tabA", "tabB", "tabC"]) {
            Color.red.tag("try tag")

            Color.green

            Color.blue
        }
        .accentColor(.yellow)
        .tint(.green)
    }
}
