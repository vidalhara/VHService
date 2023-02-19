//
//  VHService+DefaultRequest.swift
//  VHService
//
//  Created by Vidal HARA on 12.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension VHService {

    final class DefaultRequest: Request {

        let identifier: String
        var request: URLRequest
        var time: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        var data: NSMutableData?
        var retryCount = 0

        private let completion: VHService.InternalCompletion

        init(
            identifier: String? = nil, request: URLRequest,
            queue: DispatchQueue?, completion: @escaping VHService.InternalCompletion
        ) {
            self.identifier = identifier.ifNil(request.url!.path)
            self.request = request
            self.completion = { [weak queue] result in
                queue.async { completion(result) }
            }
        }
    }
}

// MARK: - Request

internal extension VHService.DefaultRequest {

    func task(in service: VHService) -> URLSessionTask {
        return service.session.dataTask(with: request)
    }

    func complete(task: URLSessionTask, error: Error?, in service: VHService) {

        let response = logResponse(for: task, error: error)

        let error = response.convertedError(with: service.environment)
        let result = Result(response, error)
        retryIfNeeded(in: service, for: error) { [weak self] in
            self?.completion(result)
        }
    }
}
