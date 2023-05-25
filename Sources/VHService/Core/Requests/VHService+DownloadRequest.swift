//
//  VHService+DownloadRequest
//  VHService
//
//  Created by Vidal HARA on 12.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension VHService {

    final class DownloadRequest: ProgressedRequest {

        let identifier: String
        var request: URLRequest
        var time: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        var responseData: NSMutableData?
        var retryCount = 0

        let progress: VHService.ProgressBlock
        private let completion: VHService.DownloadCompletion

        init(
            identifier: String? = nil,
            request: URLRequest,
            progress: @escaping VHService.ProgressBlock,
            completion: @escaping VHService.DownloadCompletion
        ) {
            self.identifier = identifier.ifNil(request.url!.path)
            self.request = request
            self.progress = progress
            self.completion = completion
        }
    }
}

// MARK: - Request

internal extension VHService.DownloadRequest {

    func task(in service: VHService) -> URLSessionTask {
        return service.session.downloadTask(with: request)
    }

    func complete(task: URLSessionTask, error: Error?, in service: VHService) {
        guard let error = error else { return }

        let response = logResponse(for: task, error: error)

        let customizedError = response.convertedError(with: service.environment)
        let responseData = response.data

        retryIfNeeded(in: service, data: responseData, for: customizedError) { [weak self, weak service] error in
            var newError = error ?? customizedError
            if let error = newError, let anError = service?.mapError(error, with: responseData) {
                newError = anError
            }
            self?.completion(Result(error: newError))
        }
    }

    func complete(task: URLSessionTask, fileURL url: URL) {

        logResponse(for: task, error: .none)

        completion(Result(url))
    }
}

