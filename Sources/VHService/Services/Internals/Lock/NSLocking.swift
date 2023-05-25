//
//  UnfairLock.swift
//  VHService
//
//  Created by Vidal HARA on 6.03.2019.
//  Copyright © 2019 Vidal HARA. All rights reserved.
//

import Foundation

internal extension NSLocking {

    func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }

    func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        closure()
    }
}

internal extension Optional where Wrapped: NSLocking {

    func around<T>(_ closure: () -> T) -> T {
        switch self {
        case .some(let locker):
            return locker.around(closure)
        case .none:
            return closure()
        }
    }

    func around(_ closure: () -> Void) {
        switch self {
        case .some(let locker):
            locker.around(closure)
        case .none:
            closure()
        }
    }
}
