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

    /// When device has no internet connection this error will be thrown
    case connection

    /// When `VHServiseEnvironment.acceptableStatusCodes` not contains the response status code then this error will be thrown
    case statusCode(_ statusCode: Int)

    /// When decode fails, this error will be thrown
    case decodeError

    /// When both error and data is nil, this error will be thrown
    case unknown
}

extension VHServiceError: LocalizedError, CustomNSError {

    /// Localized description of error
    public var localizedDescription: String {
       "We cannot process your request at the moment. Please try again later."
    }

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        return localizedDescription
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
        case .connection:
            return "Device has no internet connection"

        case .statusCode(let statusCode):
            return "Service environment not accepting status code [\(statusCode)]."

        case .decodeError:
            return "Decode fails"

        case .unknown:
            return "Unknown error occurred."
        }
    }

    /// The error code within the given domain.
    public var errorCode: Int {
        switch self {
        case .connection:
            return NSURLErrorNotConnectedToInternet

        case .statusCode(let statusCode):
            return statusCode

        case .decodeError:
            return NSURLErrorCannotDecodeContentData

        case .unknown:
            return NSURLErrorUnknown
        }
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        return [
            NSLocalizedDescriptionKey: errorDescription as Any,
            NSLocalizedFailureReasonErrorKey: failureReason as Any
        ]
    }
}
