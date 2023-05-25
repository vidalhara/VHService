//
//  VHCache.swift
//  VHService
//
//  Created by Vidal HARA on 9.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation
import UIKit

/// Store data in memory
internal class VHCache<Key: Hashable, Value>: NSObject {

    private var cache = [KeyHolder<Key>: ValueHolder<Value>]()
    private var locker: NSLock?
    private var observerToken: Any? = nil

    /// Default it clears its cache once applicationDidReceiveMemoryWarning.
    /// - Parameter clearsWhenMemoryWarning: If true it clears its cache once applicationDidReceiveMemoryWarning.
    internal init(hasLock: Bool = false, clearsWhenMemoryWarning: Bool = true) {
        super.init()
        if clearsWhenMemoryWarning {
            observerToken = NotificationCenter.default.observe(name: UIApplication.didReceiveMemoryWarningNotification) {
                [unowned self] notification in
                self.cache.removeAll()
            }
        }
        if hasLock {
            locker = NSLock()
        }
    }
}

// MARK: - Internal API

internal extension VHCache {

    subscript(_ key: Key) -> Value? {
        get {
            return locker.around {
                cache[KeyHolder(key)]?.value
            }
        }
        set {
            locker.around {
                if let newValue = newValue {
                    cache[KeyHolder(key)] = ValueHolder(newValue)
                }
                else {
                    cache.removeValue(forKey: KeyHolder(key))
                }
            }
        }
    }

    func removeValue(forKey key: Key) -> Value? {
        return locker.around {
            if let result = cache[KeyHolder(key)]?.value {
                cache.removeValue(forKey: KeyHolder(key))
                return result
            }
            return nil
        }
    }

    func removeAll() {
        locker.around {
            cache.removeAll()
        }
    }
}

// MARK: - Private API

private extension VHCache {

    final class KeyHolder<T: Hashable>: NSObject {

        public let key: T

        public override var hash: Int {
            return key.hashValue
        }

        public init(_ key: T) {
            self.key = key
        }

        public override func isEqual(_ object: Any?) -> Bool {
            guard let object = object as? KeyHolder<T> else { return false }
            return object.key == key
        }
    }

    final class ValueHolder<T> {

        public let value: T

        public init(_ value: T) {
            self.value = value
        }
    }
}
