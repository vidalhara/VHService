//
//  URLRequest+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 14.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension URLRequest {
    private var detail: String {
        return """
    \(httpMethod!.description) '\(url!.absoluteString)'
    HEADERS: \(allPrettyHeadersDescription)
    """
    }

    var vhDescription: String {
        return """
    ------------------
    \(detail)\(httpBody.vhDescription)
    ------------------------------------------------------
    """
    }

    mutating func setHeaders(_ headers: [String: String]) {
        headers.forEach {
            self.setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
}

private extension URLRequest {

    var allPrettyHeadersDescription: String {
        let headers = allHTTPHeaderFields.ifNil([:]) as NSDictionary
        return headers.description
    }
}
