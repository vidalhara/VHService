//
//  URL+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 26.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

// MARK: - URLRequest

internal extension URL {

    var urlRequest: URLRequest {
        var request = URLRequest(url: self)
        request.httpMethod = VHHTTPMethod.get.rawValue.uppercased()
        return request
    }
}
