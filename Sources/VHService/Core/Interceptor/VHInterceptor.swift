//
//  VHInterceptor.swift
//  
//
//  Created by Vidal Hara on 7.02.2023.
//

import Foundation

/// Interceptor for VHService
public protocol VHInterceptor {

    /// You can customize URLRequest in this method.
    ///
    /// - Attention: This method can be called multiple times. Ex: If you retry to send request.
    ///
    /// - Parameter request: URLRequest
    func additionalConfiguration(request: inout URLRequest)

    /// Decide to retry request if needed
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - retryCount: Current retry count of the same request
    ///   - session: URLSession of the request
    ///   - data: Data of the response if exist
    ///   - code: Error code
    ///   - error: Error of the response
    ///   - completion: Can be called directly or asynchronously in order to refresh a token
    /// - Returns: Return true when this interceptor going to decide to retry or not.
    func retry(
        _ request: URLRequest,
        retryCount: Int,
        for session: URLSession,
        data: Data?,
        code: Int,
        dueTo error: Error,
        completion: @escaping (VHService.RetryPolicy) -> Void
    ) -> Bool


    /// You can do additional actions for url response
    /// - Parameters:
    ///   - result: Result of the request. Data or Error
    ///   - urlResponse: HTTPURLResponse of the request
    func additionalAction(for result: Result<Data?, Error>, urlResponse: HTTPURLResponse?)

    /// You can map error before finalize request
    /// - Parameters:
    ///   - error: Error of the response
    ///   - code: Error code
    ///   - data: Data of the response if exist
    /// - Returns: Mapped Error. If return value is nil there wont be any change
    func mapError(_ error: Error, code: Int, with data: Data?) -> Error?
}

public extension VHInterceptor {
    func additionalConfiguration(request: inout URLRequest) {}

    func retry(
        _ request: URLRequest,
        retryCount: Int,
        for session: URLSession,
        data: Data?,
        code: Int,
        dueTo error: Error,
        completion: @escaping (VHService.RetryPolicy) -> Void
    ) -> Bool {
        return false
    }

    func additionalAction(for result: Result<Data?, Error>, urlResponse: HTTPURLResponse?) {}

    func mapError(_ error: Error, code: Int, with data: Data?) -> Error? { return nil }
}
