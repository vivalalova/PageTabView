//
//  PageTabViewModel.swift
//  test
//
//  Created by Lova on 2021/12/2.
//

import Combine
import SwiftUI

@available(iOS 14.0.0, *)
public extension PageTabView {
    final class Model: ObservableObject {
        @Published var barOffset: CGFloat = 0
        @Published var width: CGFloat = 0

        @Published var offset: CGFloat = 0
        @Published public var page: Int = 0
        var onPageUpdate: (Int) -> Void

        var bag = Set<AnyCancellable>()

        init(onPageUpdate: @escaping (Int) -> Void = { _ in }) {
            self.onPageUpdate = onPageUpdate
            $offset
                .filter { [self] _ in self.width.isNormal }
                .map { [self] in Int(round($0 / self.width)) }
                .removeDuplicates()
                
                .assign(to: \.page, on: self)
                .store(in: &self.bag)

            $page
                .sink { [self] in
                    self.onPageUpdate($0)
                }
                .store(in: &self.bag)
        }

        public func scrollTo(page: Int) {
            guard self.width.isNormal else {
                return
            }

            self.offset = CGFloat(page) * self.width
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
