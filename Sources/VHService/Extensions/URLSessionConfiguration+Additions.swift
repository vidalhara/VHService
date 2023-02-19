//
//  URLSessionConfiguration+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 11.05.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

public extension URLSessionConfiguration {

    /// Default VHService session.
    ///
    /// Request cache policy is `URLRequest.CachePolicy.reloadIgnoringCacheData`.
    /// `URLSessionConfiguration.urlCache` is nil.
    /// Timeout interval for request is 25.
    /// Timeout interval for resource  is 50.
    static func vhDefault() -> URLSessionConfiguration {
        let session = URLSessionConfiguration.background(withIdentifier: "com.vhservice.backgroundsession.\(UUID().uuidString)")
        session.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.urlCache = nil
        session.timeoutIntervalForRequest = 25
        session.timeoutIntervalForResource = 50
        return session
    }
}
