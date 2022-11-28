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
