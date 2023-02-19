//
//  Dictionary+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 28.09.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String {

    /// Flatten dictionary keys
    ///
    /// - Ex:
    ///
    /// ````
    /// let dict = {
    ///     "Hello": {
    ///         "World": "1"
    ///     }
    /// }
    /// let flattenedDict = dict.vhFlattenedKeys()
    /// print(flattenedDict) // "Hello.World": "1"
    /// ````
    ///
    /// - Parameters:
    ///   - oldKey: Previous key for prefix. Default value is empty string.
    ///   - seperator: Seperator of keys. Default value is "."
    ///   - map: When you reaching to a certain data(T) convert it to a value(U)
    /// - Returns: Flattened dictionary
    func vhFlattenedKeys<T, U>(
        oldKey: String = "", seperator: String = ".", map: (_ data: T) -> U?
    ) -> [String: U] {
        var newData: [String: U] = [:]
        for (key, value) in self {
            let newKey = oldKey.isEmpty ? key : (oldKey + seperator + key)
            if let colorDict = value as? T,
               let value = map(colorDict) {
                newData[newKey] = value
            } else if let data = value as? [String: Any] {
                let nextData = data.vhFlattenedKeys(oldKey: newKey, seperator: seperator, map: map)
                newData.merge(nextData) { (current, _) in current }
            }
        }
        return newData
    }
}
