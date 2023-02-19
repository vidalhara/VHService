//
//  VHRequest+URLRequest.swift
//  VHService
//
//  Created by Vidal HARA on 25.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension VHRequest {

    func urlRequest(with service: VHService, defaultTimeout: TimeInterval) -> URLRequest {
        let environment = service.environment
        let components = URLComponents(environment: environment, task: self)
        guard let url = components.url else {
            let message = "Generated url is not valid: Component: \(components))"
            VHServiceLogger.log(message, level: .error)
            preconditionFailure(message)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()

        let headers = service.environment.additionalHTTPHeaders.merging(additionalHeaders) { _, rhs in
            return rhs
        }
        request.setHeaders(headers)
        request.httpBody = method == .get ? nil : body?.data()
        request.timeoutInterval = self.timeoutInterval.ifNil(defaultTimeout)

        return request
    }
}

// MARK: - URLComponents

private extension URLComponents {

    init(environment: VHServiceEnvironment, task: VHRequest) {
        self.init()
        host = environment.host
        port = Int(environment.port)
        path = task.path
        queryItems = task.queryItems
        scheme = task.scheme
    }
}
