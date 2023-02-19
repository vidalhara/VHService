//
//  VHServiceErrors.swift
//  VHService
//
//  Created by Vidal HARA on 10.06.2018.
//  Copyright © 2018 Vidal HARA. All rights reserved.
//

import UIKit

/// Service Errors
public enum VHServiceError: Error {

    /// When `VHServiseEnvironment.acceptableStatusCodes` not contains the response status code then this error will be thrown
    case statusCode(_ statusCode: Int)

    /// When both error and data is nil, this error will be thrown
    case unknown
}

extension VHServiceError: LocalizedError, CustomNSError {

    /// Localized description of error
    public var localizedDescription: String {
        switch self {
        case .statusCode(let statusCode):
            return "Service environment not accepting status code [\(statusCode)]."

        case .unknown:
            return "Unknown error occurred."
        }
    }

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        return localizedDescription
    }

    /// The error code within the given domain.
    public var errorCode: Int {
        switch self {
        case .statusCode(let statusCode):
            return statusCode

        case .unknown:
            return -1
        }
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        return [NSLocalizedFailureReasonErrorKey: errorDescription as Any]
    }
}
