//
//  File.swift
//
//
//  Created by Lova on 2021/9/27.
//

import SwiftUI

public
struct TabTitle<TitleView: View>: ViewModifier {
    public var tabTitle: TitleView

    public func body(content: Content) -> some View {
        content
    }
}

public
extension View {
    func tabTitle<TitleView: View>(_ title: TitleView) -> some View {
        modifier(TabTitle(tabTitle: title))
    }
}
