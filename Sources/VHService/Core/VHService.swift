//
//  VHService.swift
//  VHService
//
//  Created by Vidal HARA on 5.06.2018.
//  Copyright © 2018 Vidal HARA. All rights reserved.
//

import UIKit

/// VHService which hepls you to send basic HTTP Requests & Download Requests & Upload Requests
open class VHService {

    /// This is the `ComponentAPIRequest.send(...)` or ` ComponentAPIRequest.upload(...)` completion block type
    public typealias Completion = (Result<Data, Error>) -> Void
    /// This is the `ComponentAPIRequest.download(...)` completion block type
    ///
    /// - Attention: Url is a temporary directory you should move or use it when this block called.
    public typealias DownloadCompletion = (Result<URL, Error>) -> Void
    /// This is the `ComponentAPIRequest.download(...)` or ` ComponentAPIRequest.upload(...)` progress block type
    public typealias ProgressBlock = (_ progress: CGFloat, _ current: Int64, _ total: Int64) -> Void

    internal typealias InternalCompletion = (Result<Response, Error>) -> Void

    /// If true service cancels the previous task which has same `VHHTTPTask.identifier`. Default value is true.
    public var cancelsPreviousOperations: Bool = true

    /// Environment of the service. If changed, new environment will only used for the new sended requests.
    public var environment: VHServiceEnvironment

    internal lazy var sessionDelegate: SessionDelegate = SessionDelegate(for: self)

    /// Session of the service
    public private(set) lazy var session: URLSession = URLSession(configuration: .vhDefault(), delegate: sessionDelegate, delegateQueue: nil)

    private lazy var cancelOperations: [String: () -> Void] = [:]
    private let lock = UnfairLock()

    /// You can use Service to send requests
    /// - Parameter environment: Settings of the service
    /// - Parameter configuration: URLSessionConfiguration. If you want, you can use predefined `URLSessionConfiguration.vhDefault()` or `URLSessionConfiguration.vhBackground()`
    public init(environment: VHServiceEnvironment, configuration: URLSessionConfiguration = .vhDefault()) {
        self.environment = environment
        self.session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)
    }

    /// You can send your request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - queue: Queue to run completion
    ///   - completion: Completion block of the request
    open func send(
        _ request: VHRequest, queue: DispatchQueue? = .main, completion: @escaping Completion
    ) {
        send(request, queue: queue, internalCompletion: { result in
            completion(result.compactMap({ $0.data }))
        })
    }

    /// You can send your request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - queue: Queue to run completion
    ///   - completion: Completion block of the request with HTTPURLResponse
    open func sendHTTP(
        _ request: VHRequest, queue: DispatchQueue? = .main, completion: @escaping (Result<(Data?, HTTPURLResponse), Error>) -> Void
    ) {
        send(request, queue: queue, internalCompletion: { result in
            let newResult = result.compactMap { result -> (Data?, HTTPURLResponse)? in
                if let response = result.response {
                    return (result.data, response)
                }
                return nil
            }
            completion(newResult)
        })
    }

    private func send(
        _ request: VHRequest, queue: DispatchQueue?, internalCompletion: @escaping InternalCompletion
    ) {
        let urlRequest = request.urlRequest(with: self, defaultTimeout: session.configuration.timeoutIntervalForRequest)
        let request = DefaultRequest(
            identifier: request.identifier, request: urlRequest, queue: queue, completion: internalCompletion
        )
        request.start(in: self)
    }

    /// You can send your GET request to URL in this method
    ///
    /// - Parameters:
    ///   - url: URL you want to send GET Request
    ///   - queue: Queue to run completion
    ///   - completion: Completion block of the request
    open func send(
        _ url: URL, queue: DispatchQueue? = .main, completion: @escaping Completion
    ) {
        let urlRequest = url.urlRequest
        let request = DefaultRequest(request: urlRequest, queue: queue) { result in
            completion(result.compactMap({ $0.data }))
        }
        request.start(in: self)
    }

    /// You can send your download request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - progress: Progress block of the download request. Block called in request queue.
    ///   - completion: Completion block of the download request. Block called in request queue.
    open func download(
        _ request: VHRequest, progress: @escaping ProgressBlock, completion: @escaping DownloadCompletion
    ) {
        let urlRequest = request.urlRequest(with: self, defaultTimeout: session.configuration.timeoutIntervalForResource)
        let request = DownloadRequest(
            identifier: request.identifier, request: urlRequest, progress: progress, completion: completion
        )
        request.start(in: self)
    }

    /// You can send your download GET request in this method
    ///
    /// - Parameters:
    ///   - url: URL you want to send GET Request
    ///   - progress: Progress block of the download request. Block called in request queue.
    ///   - completion: Completion block of the download request. Block called in request queue.
    open func download(
        _ url: URL, progress: @escaping ProgressBlock, completion: @escaping DownloadCompletion
    ) {
        let urlRequest = url.urlRequest
        let request = DownloadRequest(
            request: urlRequest, progress: progress, completion: completion
        )
        request.start(in: self)
    }

    /// You can send your upload request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - fileURL: The URL of the file to upload
    ///   - progress: Progress block of the upload request. Block called in request queue.
    ///   - completion: Completion block of the upload request. Block called in request queue.
    open func upload(
        _ request: VHRequest, fileURL: URL, progress: @escaping ProgressBlock, completion: @escaping Completion
    ) {
        var urlRequest = request.urlRequest(with: self, defaultTimeout: session.configuration.timeoutIntervalForResource)
        urlRequest.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        let request = UploadRequest(
            identifier: request.identifier,
            request: urlRequest,
            fileURL: fileURL,
            progress: progress,
            completion: completion
        )
        request.start(in: self)
    }

    /// You can customize URLRequest in this method.
    ///
    /// - Attention: This method can be called multiple times. Ex: If you retry to send request.
    ///
    /// - Parameter request: URLRequest
    open func additionalConfigure(request: inout URLRequest) {}

    /// Decide to retry request if needed
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - retryCount: Current retry count of the same request
    ///   - session: URLSession of the request
    ///   - error: Error of the response
    ///   - completion: Can be called directly or asynchronously in order to refresh a token
    open func retry(
        _ request: URLRequest,
        retryCount: Int,
        for session: URLSession,
        dueTo error: Error,
        completion: @escaping (RetryPolicy) -> Void
    ) {
        completion(.doNotRetry)
    }

    /// Cancels all the requests
    open func cancelAll() {
        cancelOperations.values.forEach { $0() }
        cancelOperations.removeAll()
    }

    deinit {
        cancelAll()
        session.invalidateAndCancel()
    }
}

// MARK: - CancelOperations

internal extension VHService {

    func removeCancelation(for identifier: String) {
        lock.around {
            _ = cancelOperations.removeValue(forKey: identifier)
        }
    }

    func configureCancelation(for task: URLSessionTask, identifier: String) {
        lock.around {
            if cancelsPreviousOperations, let cancel = cancelOperations[identifier] {
                cancel()
            }

            cancelOperations[identifier] = { [weak task] in
                task?.cancel()
            }
        }
    }
}
