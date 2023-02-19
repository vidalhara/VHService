//
//  Data+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 14.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension Data {

    init?(_ data: NSMutableData?) {
        guard let data = data else { return nil }
        self = Data(referencing: data)
    }
}

internal extension Optional where Wrapped == Data {

    var vhDescription: String {
        guard case let .some(data) = self,
              let result = data.normalizing() else { return "" }

        return "\nBODY: \(result)"
    }
}

fileprivate extension Data {

    /// Converts data to [String: Any]
    func normalizing() -> String? {
        return tring(logs: false) {
            let object = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)
        }
    }
}
