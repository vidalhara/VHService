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

    var data: NSMutableData? { get set }

    func task(in service: VHService) -> URLSessionTask

    func complete(task: URLSessionTask, error: Error?, in service: VHService)
}

internal extension Request {

    func start(in service: VHService) {
        service.additionalConfigure(request: &request)
        let task = self.task(in: service)

        service.configureCancelation(for: task, identifier: identifier)
        service.sessionDelegate.requests[task.taskIdentifier] = self

        VHServiceLogger.log(request.vhDescription, level: .request)
        clear()
        task.resume()
    }

    @discardableResult
    func logResponse(for task: URLSessionTask, error: Error?) -> VHService.Response {
        let response = VHService.Response(
            requestTime: time, data: Data(self.data), response: task.response, error: error
        )
        VHServiceLogger.log(response.description, level: .response)

        return response
    }

    func retryIfNeeded(in service: VHService, for error: Error?, finalizer: @escaping () -> Void) {
        guard let error = error, error.isCanceled == false else {
            finalizer()
            return
        }

        service.retry(request, retryCount: retryCount, for: service.session, dueTo: error) { [weak service] policy in
            guard let service = service else { return }
            switch policy {
            case .doNotRetry:
                finalizer()

            case .retry:
                self.retryCount += 1
                self.start(in: service)
            }
        }
    }

    func append(data: Data) {
        if self.data == nil {
            self.data = NSMutableData()
        }
        self.data?.append(data)
    }

    private func clear() {
        time = CFAbsoluteTimeGetCurrent()
        data = .none
    }
}

// MARK: - ProgressedRequest

internal protocol ProgressedRequest: Request {

    var progress: VHService.ProgressBlock { get }
}
