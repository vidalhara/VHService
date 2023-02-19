//
//  URLResponder+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 14.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension Optional where Wrapped: URLResponse {

    func description(with data: Data?, error: Error?, elapseTime: CFAbsoluteTime) -> String {
        let errorDescription = error == nil ? "" : "\nError: \(error!.localizedDescription)"

        return """
    ------------------
    \(responseDescription(elapseTime: elapseTime))\(errorDescription)\(data.vhDescription)
    ------------------------------------------------------
    """
    }

    private func responseDescription(elapseTime: CFAbsoluteTime) -> String {
        guard case let .some(item) = self, let response = item as? HTTPURLResponse else { return "" }
        let time = String(format: "%.04f", elapseTime)
        return """
    \(response.statusCode) '\(response.url!.absoluteString)' [\(time) s]
    HEADERS: \(response.prettifyHeaders)
    """
    }
}

private extension HTTPURLResponse {

    var prettifyHeaders: String {
        return (allHeaderFields as NSDictionary).description
    }
}
