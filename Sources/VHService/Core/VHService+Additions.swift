//
//  VHService+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 12.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

// MARK: - WeakHolder

internal extension VHService {

    final class WeakHolder<T: AnyObject> {

        public weak var item: T?

        public init(_ item: T) {
            self.item = item
        }
    }
}

// MARK: - ResponseFinalizer

internal extension Optional where Wrapped == DispatchQueue {
    func async(_ block: @escaping () -> Void) {
        switch self {
        case .none:
            block()
        case .some(let wrapped):
            wrapped.async(execute: block)
        }
    }
}
