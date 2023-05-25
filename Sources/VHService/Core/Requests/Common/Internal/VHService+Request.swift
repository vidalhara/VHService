//
//  VHService+Request.swift
//  VHService
//
//  Created by Vidal HARA on 11.05.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal protocol Request: AnyObject {

    var identifier: String { get }
    var request: URLRequest { get set }
    var time: CFAbsoluteTime { get set }
    var retryCount: Int { get set }

    var responseData: NSMutableData? { get set }

    func task(in service: VHService) -> URLSessionTask

    func complete(task: URLSessionTask, error: Error?, in service: VHService)
}

internal extension Request {

    func start(in service: VHService) {
        service.additionalConfigure(request: &request)
        let task = self.task(in: service)

        service.configureCancelation(for: task, identifier: identifier)
        service.sessionDelegate.add(request: self, for: task.taskIdentifier)

        VHServiceLogger.log(request.vhDescription, level: .request)
        clear()

        if service.connectionService.isDisconnected == false {
            task.resume()
        } else {
            service.sessionDelegate.complete(task: task, with: VHServiceError.connection)
        }
    }

    @discardableResult
    func logResponse(for task: URLSessionTask, error: Error?) -> VHService.Response {
        let response = VHService.Response(
            requestTime: time, data: Data(self.responseData), response: task.response, error: error
        )
        VHServiceLogger.log(response.description, level: .response)

        return response
    }

    func retryIfNeeded(in service: VHService, data: Data?, for error: Error?, finalizer: @escaping (Error?) -> Void) {
        guard let error = error, error.isCanceled == false else {
            finalizer(nil)
            return
        }

        service.retry(request, retryCount: retryCount, for: service.session, data: data, dueTo: error) { [weak service] policy in
            guard let service = service else { return }
            switch policy {
            case .doNotRetry:
                finalizer(nil)

            case .retry:
                self.retryCount += 1
                self.start(in: service)

            case .throwCancelError:
                finalizer(CancelError())
            }
        }
    }

    func append(data: Data) {
        if self.responseData == nil {
            self.responseData = NSMutableData()
        }
        self.responseData?.append(data)
    }

    private func clear() {
        time = CFAbsoluteTimeGetCurrent()
        responseData = .none
    }
}

// MARK: - ProgressedRequest

internal protocol ProgressedRequest: Request {

    var progress: VHService.ProgressBlock { get }
}

private struct CancelError: LocalizedError, CustomNSError {

    var localizedDescription: String { "Request canceled" }
    var errorDescription: String? { localizedDescription }

    public var failureReason: String? { localizedDescription }

    /// The error code within the given domain.
    public var errorCode: Int { NSURLErrorCancelled }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        return [
            NSLocalizedDescriptionKey: errorDescription as Any,
            NSLocalizedFailureReasonErrorKey: failureReason as Any
        ]
    }
}
