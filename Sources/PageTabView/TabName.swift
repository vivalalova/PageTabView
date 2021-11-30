//
//  File.swift
//
//
//  Created by Lova on 2021/12/1.
//

import SwiftUI

extension EnvironmentValues {
    private struct TabName: EnvironmentKey {
        static let defaultValue: String = ""
    }

    var tabName: String {
        get { self[TabName.self] }
        set { self[TabName.self] = newValue }
    }
}

extension View {
    func tab(_ value: String) -> some View {
        environment(\.tabName, value)
    }
}
