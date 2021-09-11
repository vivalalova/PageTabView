//
//  PageTabView.swift
//  PageTabView
//
//  Created by Lova on 2021/8/27.
//

import SwiftUI

public
struct PageTabView<Content: View>: View {
    @State var offset: CGFloat = 0

    let content: () -> Content

    @State var titles: [String]

    public
    init(titles: [String], @ViewBuilder content: @escaping () -> Content) {
        self.titles = titles
        self.content = content
    }

    @State var barOffset: CGFloat = 0
    @State var numberOfPage: CGFloat = 0

    public
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {} label: {
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

                    ForEach(self.titles.dropFirst(), id: \.self) { title in
                        Button {} label: {
                            Text(title)
                                .font(.title3)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .frame(height: 44)

                OffsetTabView(offset: $offset) {
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
