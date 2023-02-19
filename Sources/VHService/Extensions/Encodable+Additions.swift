//
//  Encodable+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 10.06.2018.
//  Copyright © 2018 Vidal HARA. All rights reserved.
//

import Foundation

public extension Encodable {

    /// Encode your Object
    ///
    /// - Returns: Encodate data or nil and logs error with VHServiceLogger
    func encode() -> Data? {
        do {
            let object = try JSONEncoder().encode(self.self)
            return object
        } catch EncodingError.invalidValue(let key, let context) {
            VHServiceLogger.log("\(key), \(context)", level: .codingError)
        } catch let err {
            VHServiceLogger.log("Encode error: \(err.localizedDescription)", level: .codingError)
        }
        return nil
    }
}
