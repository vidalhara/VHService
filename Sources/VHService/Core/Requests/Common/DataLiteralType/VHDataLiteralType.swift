//
//  VHDataLiteralType.swift
//  VHService
//
//  Created by Vidal HARA on 10.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

/// VHDataLiteralType used for representing any object as a Data.
public protocol VHDataLiteralType {

    /// Convert your object to data
    func data() -> Data?
}

// MARK: - Data

extension Data: VHDataLiteralType {

    public func data() -> Data? { return self }
}

// MARK: - Dictionary

extension Dictionary: VHDataLiteralType {

    public func data() -> Data? {
        return tring {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        }
    }
}

// MARK: - Array

extension Array: VHDataLiteralType where Element: Encodable {}

// MARK: - Encodable

public extension Encodable where Self: VHDataLiteralType {

    /// Converts VHDataLiteralType to data using `Encodable.encode()`
    /// - Returns: Optional Data
    func data() -> Data? { return encode() }
}
