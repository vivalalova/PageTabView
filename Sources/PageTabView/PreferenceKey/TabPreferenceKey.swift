//
//  TabPreferenceKey.swift
//  TabPreferenceKey
//
//  Created by Lova on 2021/8/31.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct TabPreferenceKey: PreferenceKey {
    static var defaultValue = CGRect()

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
