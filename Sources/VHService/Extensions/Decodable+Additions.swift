//
//  Decodable+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 14.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

public extension Decodable {
    /// Decode your Data
    ///
    /// - Parameters:
    ///   - data: Data you want to Decode
    /// - Returns: Decodable Object or nil and logs error with VHLogger
    static func decode(from data: Data) -> Self? {
        let decodeError: (_ context: DecodingError.Context, _ msg: String) -> String = {
            (context, msg) in
            return """

      < type: \(msg),
      < path: \(context.codingPath.map({$0.stringValue})),
      < message: \(context.debugDescription)>
      """
        }

        do {
            let object: Self = try decoding(data: data)
            return object
        } catch DecodingError.typeMismatch(_, let context) {
            VHServiceLogger.log(decodeError(context, "typeMismatch"), level: .codingError)
        } catch DecodingError.keyNotFound(_, let context) {
            VHServiceLogger.log(decodeError(context, "keyNotFound"), level: .codingError)
        } catch DecodingError.valueNotFound(_, let context) {
            VHServiceLogger.log(decodeError(context, "valueNotFound"), level: .codingError)
        } catch DecodingError.dataCorrupted(let context) {
            VHServiceLogger.log(decodeError(context, "dataCorrupted"), level: .codingError)
        } catch let err {
            VHServiceLogger.log(err.localizedDescription, level: .codingError)
        }
        return nil
    }

    /// Decode your Data
    /// - Parameter data: Data you want to Decode
    static func decoding(data: Data) throws -> Self {
        do {
            let object = try JSONDecoder().decode(Self.self, from: data)
            return object
        } catch {
            throw error
        }
    }
}
