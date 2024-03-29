//
//  VHService+UploadRequest.swift
//  VHService
//
//  Created by Vidal HARA on 26.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension VHService {

    final class UploadRequest: ProgressedRequest {

        let identifier: String
        var request: URLRequest
        var time: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
        var responseData: NSMutableData?
        var retryCount = 0

        let progress: VHService.ProgressBlock

        private let fileURL: URL
        private let completion: VHService.Completion

        init(
            identifier: String? = nil,
            request: URLRequest,
            fileURL: URL,
            progress: @escaping VHService.ProgressBlock,
            completion: @escaping VHService.Completion
        ) {
            self.identifier = identifier.ifNil(request.url!.path)
            self.request = request
            self.fileURL = fileURL
            self.progress = progress
            self.completion = completion
        }
    }
}

// MARK: - Request

internal extension VHService.UploadRequest {

    func task(in service: VHService) -> URLSessionTask {
        return service.session.uploadTask(with: request, fromFile: fileURL)
    }

    func complete(task: URLSessionTask, error: Error?, in service: VHService) {

        let response = logResponse(for: task, error: error)

        let error = response.convertedError(with: service.environment)
        let result = Result(Data(responseData), error)
        let responseData = response.data
        retryIfNeeded(in: service, data: responseData, for: error) { [weak self, weak service] customError in
            let result = result.failIfNeeded(customError)
            let newResult = result.mapError { [weak service] error in
                return service?.mapError(error, with: responseData) ?? error
            }
            self?.completion(newResult)
        }
    }
}
