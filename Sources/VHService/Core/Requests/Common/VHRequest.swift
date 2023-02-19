//
//  VHRequest.swift
//  VHService
//
//  Created by Vidal HARA on 5.06.2018.
//  Copyright © 2018 Vidal HARA. All rights reserved.
//

import UIKit

/// VHService supported Http methods
public enum VHHTTPMethod: String {
    /// HTTP GET Method
    case get
    /// HTTP POST Method
    case post
    /// HTTP DELETE Method
    case delete
    /// HTTP PATCH Method
    case patch
    /// HTTP PUT Method
    case put
    /// HTTP CLEAR Method
    case clear
}

/// This is a request builder for VHService
public protocol VHRequest {

    /// Path of the request
    var path: String { get }

    /// Http method of the request
    var method: VHHTTPMethod { get }

    /// Body of the request
    var body: VHDataLiteralType? { get }

    /// Headers of the request
    var additionalHeaders: [String: String] { get }

    /// Query items of the request
    var queryItems: [URLQueryItem]? { get }

    /// If it is secure scheme will be https otherwise http. Default value is true.
    var isSecure: Bool { get }

    /// Identifier of the task for canceling previous same request when `VHService.cancelsPreviousOperations` is **true**. Default value is same as path value.
    var identifier: String { get }

    /// Timeout interval of the request
    var timeoutInterval: TimeInterval? { get }
}

// MARK: - VHRequest

public extension VHRequest {

    var body: VHDataLiteralType? { return nil }
    var additionalHeaders: [String: String] { return [:] }
    var queryItems: [URLQueryItem]? { return nil }
    var isSecure: Bool { return true }
    var identifier: String { return path }
    var timeoutInterval: TimeInterval? { return nil }
}

internal extension VHRequest {

    var scheme: String { return isSecure ? "https" : "http" }
}
