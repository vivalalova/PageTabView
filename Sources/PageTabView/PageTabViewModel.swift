//
//  PageTabViewModel.swift
//  test
//
//  Created by Lova on 2021/12/2.
//

import Combine
import SwiftUI

@available(iOS 13.0.0, *)
public extension PageTabView {
    final class Model: ObservableObject {
        @Published var barOffset: CGFloat = 0
        @Published var numberOfPage: Int = 0
        @Published var width: CGFloat = 0

        @Published var offset: CGFloat = 0
        @Published public var page: Int = 0

        @Published var orientation = UIDeviceOrientation.unknown

        var bag = Set<AnyCancellable>()

        init() {
            $page
                .filter { [self] _ in self.width > 0 }
                .map { [self] in CGFloat($0) * self.width }
                .assign(to: \.offset, on: self)
                .store(in: &self.bag)
        }

        func onPress(index: Int, width: CGFloat) -> () -> Void {
            return {
                let offset = CGFloat(index) * width
                if self.offset != offset {
                    self.offset = offset
                    self.barOffset = offset / width
                }
            }
        }
    }
}
