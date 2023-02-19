//
//  UnfairLock.swift
//  VHService
//
//  Created by Vidal HARA on 6.03.2019.
//  Copyright © 2019 Vidal HARA. All rights reserved.
//

import Foundation

/// A thin wrapper around `os_unfair_lock`.
internal final class UnfairLock {

    private var unfairLock = os_unfair_lock()

    private func lock() {
        os_unfair_lock_lock(&unfairLock)
    }

    private func unlock() {
        os_unfair_lock_unlock(&unfairLock)
    }

    func around<T>(_ closure: () -> T) -> T {
        lock(); defer { unlock() }
        return closure()
    }

    func around(_ closure: () -> Void) {
        lock(); defer { unlock() }
        closure()
    }
}

internal extension Optional where Wrapped == UnfairLock {

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
