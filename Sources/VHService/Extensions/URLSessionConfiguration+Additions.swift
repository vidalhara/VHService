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
    /// - Returns: URLSessionConfiguration
    static func vhDefault() -> URLSessionConfiguration {
        let session = URLSessionConfiguration.default
        session.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.urlCache = nil
        session.timeoutIntervalForRequest = 25
        session.timeoutIntervalForResource = 50
        return session
    }

    /// Background VHService session.
    ///
    /// Request cache policy is `URLRequest.CachePolicy.reloadIgnoringCacheData`.
    /// `URLSessionConfiguration.urlCache` is nil.
    /// Timeout interval for resource  is 50.
    /// - Parameter identifier: Identifier of the backgroundSession
    /// - Returns: Background URLSessionConfiguration
    static func vhBackground(identifier: String = "com.vhservice.backgroundsession.\(UUID().uuidString)") -> URLSessionConfiguration {
        let session = URLSessionConfiguration.background(withIdentifier: identifier)
        session.requestCachePolicy = .reloadIgnoringLocalCacheData
        session.urlCache = nil
        session.timeoutIntervalForRequest = 50
        session.timeoutIntervalForResource = 50
        return session
    }
}
