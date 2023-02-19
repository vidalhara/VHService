//
//  VHService+Response.swift
//  VHService
//
//  Created by Vidal HARA on 25.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension VHService {

    struct Response: CustomStringConvertible {
        public let requestTime: CFAbsoluteTime
        public let responseTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()

        public let data: Data?
        public let response: HTTPURLResponse?
        public let error: Error?


        public init(requestTime: CFAbsoluteTime, data: Data?, response: URLResponse?, error: Error?) {
            self.requestTime = requestTime
            self.data = data
            self.response = response as? HTTPURLResponse
            self.error = error
        }

        public func convertedError(with environment: VHServiceEnvironment) -> Error? {
            var error: Error? = self.error
            if let response = response,
               environment.acceptableStatusCodes.contains(response.statusCode) == false
            {
                error = VHServiceError.statusCode(response.statusCode)
            }
            return error
        }

        var description: String {
            return response.description(with: data, error: error, elapseTime: responseTime - requestTime)
        }
    }
}
