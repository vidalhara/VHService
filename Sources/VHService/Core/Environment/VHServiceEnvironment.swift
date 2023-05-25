//
//  VHServiceEnvironment.swift
//  VHService
//
//  Created by Vidal HARA on 14.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

/// Environment to create service
public protocol VHServiceEnvironment {

    /// Host of the url
    var host: String { get }
    /// Port of the url. Default value is empty string.
    var port: String { get }

    /// Acceptable HTTP status codes. Default value is **Set(200...299)**.
    var acceptableStatusCodes: Set<Int> { get }

    /// Additinal HTTP headers. Defalt is an **empty** Dictionary.
    var additionalHTTPHeaders: [String: String] { get }
}

public extension VHServiceEnvironment {

    var port: String { "" }

    var acceptableStatusCodes: Set<Int> { return Set(200...299) }
    var additionalHTTPHeaders: [String: String] { return [:] }
}
