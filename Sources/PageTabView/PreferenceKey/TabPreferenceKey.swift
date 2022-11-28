//
//  TabPreferenceKey.swift
//  TabPreferenceKey
//
//  Created by Lova on 2021/8/31.
//

import SwiftUI

struct TabPreferenceKey: PreferenceKey {
    public static var defaultValue = CGRect()

    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct PageTitlePreferenceKey: PreferenceKey {
    public typealias T = any View

    public static var defaultValue: T = EmptyView()

    public static func reduce(value: inout T, nextValue: () -> T) {
        value = nextValue()
    }
}

// MARK: - TitleView

struct TitleViewPreferenceKey: PreferenceKey {
    static var defaultValue = Wrapper(value: Text(""))

    static func reduce(value: inout Wrapper, nextValue: () -> Wrapper) {
        value = nextValue()
    }

    struct Wrapper: Equatable {
        var value: any View = EmptyView()

        static func == (lhs: Wrapper, rhs: Wrapper) -> Bool {
            true
        }
    }
}

public extension View {
    func pageTitle(_ view: any View) -> some View {
        self.preference(key: TitleViewPreferenceKey.self, value: TitleViewPreferenceKey.Wrapper(value: view))
    }
}
