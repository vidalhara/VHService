//
//  VHService+Combine.swift
//  VHService
//
//  Created by Vidal HARA on 16.03.2022.
//  Copyright © 2022 Vidal HARA. All rights reserved.
//

#if canImport(Combine)
import Foundation
import Combine

@available(iOS 13.0, *)
public extension VHService {

    /// You can send your request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - queue: Queue to run Future
    /// - Returns: A publisher that eventually produces a Data or fails.
    func send(_ request: VHRequest, queue: DispatchQueue? = nil) -> Future<Data, Error> {
        return .init { [weak self, weak queue] seal in
            self?.send(request, queue: queue) { result in
                seal(result)
            }
        }
    }

    /// You can send your request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - queue: Queue to run completion
    /// - Returns: A publisher that eventually produces (Data?, HTTPURLResponse) or fails.
    func sendHTTP(_ request: VHRequest, queue: DispatchQueue? = nil) -> Future<(Data?, HTTPURLResponse), Error> {
        return .init { [weak self, weak queue] seal in
            self?.sendHTTP(request, queue: queue) { result in
                seal(result)
            }
        }
    }

    /// You can send your GET request to URL in this method
    ///
    /// - Parameters:
    ///   - url: URL you want to send GET Request
    ///   - queue: Queue to run completion
    /// - Returns: A publisher that eventually produces a Data or fails.
    func send(_ url: URL, queue: DispatchQueue? = nil) -> Future<Data, Error> {
        return .init { [weak self, weak queue] seal in
            self?.send(url, queue: queue) { result in
                seal(result)
            }
        }
    }

    /// You can send your download request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - progress: Progress block of the download request. Block called in request queue.
    /// - Returns: A publisher that eventually produces an URL or fails.
    func download(_ request: VHRequest, progress: @escaping ProgressBlock) -> Future<URL, Error> {
        return .init { [weak self] seal in
            self?.download(request, progress: progress) { result in
                seal(result)
            }
        }
    }

    /// You can send your download GET request in this method
    ///
    /// - Parameters:
    ///   - url: URL you want to send GET Request
    ///   - progress: Progress block of the download request. Block called in request queue.
    /// - Returns: A publisher that eventually produces an URL or fails.
    func download(_ url: URL, progress: @escaping ProgressBlock) -> Future<URL, Error> {
        return .init { [weak self] seal in
            self?.download(url, progress: progress) { result in
                seal(result)
            }
        }
    }

    /// You can send your upload request in this method
    ///
    /// - Parameters:
    ///   - request: `VHRequest` you want to send
    ///   - fileURL: The URL of the file to upload
    ///   - progress: Progress block of the upload request. Block called in request queue.
    /// - Returns: A publisher that eventually produces a Data or fails.
    func upload(_ request: VHRequest, fileURL: URL, progress: @escaping ProgressBlock) -> Future<Data, Error> {
        return .init { [weak self] seal in
            self?.upload(request, fileURL: fileURL, progress: progress) { result in
                seal(result)
            }
        }
    }
}

#endif
