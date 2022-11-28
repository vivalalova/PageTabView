//
//  File.swift
//
//
//  Created by Lova on 2022/11/28.
//

import SwiftUI

// MARK: - TitleView

struct TitleViewPreferenceKey: PreferenceKey {
    static let defaultValue = Wrapper(value: Text(""))

    static func reduce(value: inout Wrapper, nextValue: () -> Wrapper) {
        value = nextValue()
    }
}

struct Wrapper: Equatable {
    let value: any View

    static func == (lhs: Wrapper, rhs: Wrapper) -> Bool {
        false
    }
}

public extension View {
    func pageTitleView<Content: View>(@ViewBuilder _ view: () -> Content) -> some View {
        preference(key: TitleViewPreferenceKey.self, value: Wrapper(value: view()))
    }
}
