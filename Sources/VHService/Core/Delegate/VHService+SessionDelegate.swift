//
//  VHService+SessionDelegate.swift
//  VHService
//
//  Created by Vidal HARA on 25.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension VHService {

    class SessionDelegate: NSObject {
        private lazy var requests: VHCache<Int, Request> = .init(hasLock: true, clearsWhenMemoryWarning: false)
        private weak var service: VHService?

        internal init(for service: VHService) {
            self.service = service
        }

        internal func add(request: Request, for identifier: Int) {
            requests[identifier] = request
        }

        internal func remove(task: URLSessionTask) -> Request? {
            if let request = requests.removeValue(forKey: task.taskIdentifier) {
                service?.removeCancelation(for: request.identifier)
                return request
            }
            return .none
        }

        internal func complete(task: URLSessionTask, with error: Error?) {
            let request = remove(task: task)
            if let service = service {
                request?.complete(task: task, error: error, in: service)
            }
        }
    }
}

// MARK: - URLSessionTaskDelegate

extension VHService.SessionDelegate: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        complete(task: task, with: error)
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        guard let request = requests[task.taskIdentifier] as? ProgressedRequest,
              totalBytesExpectedToSend != NSURLSessionTransferSizeUnknown else { return }

        request.progress(totalBytesSent.cg ^/ totalBytesExpectedToSend.cg, totalBytesSent, totalBytesExpectedToSend)
    }
}

// MARK: - URLSessionDataDelegate

extension VHService.SessionDelegate: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        requests[dataTask.taskIdentifier]?.append(data: data)
    }
}

// MARK: - URLSessionDownloadDelegate

extension VHService.SessionDelegate: URLSessionDownloadDelegate {

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let item = requests[downloadTask.taskIdentifier] as? VHService.DownloadRequest else { return }

        item.complete(task: downloadTask, fileURL: location)
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        guard let item = requests[downloadTask.taskIdentifier] as? ProgressedRequest,
              totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }

        item.progress(totalBytesWritten.cg ^/ totalBytesExpectedToWrite.cg, totalBytesWritten, totalBytesExpectedToWrite)
    }
}
