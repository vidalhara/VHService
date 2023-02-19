//
//  Any+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 9.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension Optional where Wrapped: Any {

    func ifNil(_ value: @autoclosure () -> Wrapped) -> Wrapped {
        switch self {
        case .none:
            return value()
        case .some(let value):
            return value
        }
    }
}

internal func tring<T>(logs: Bool = true, _ body: () throws -> T?) -> T? {

    do {
        let data = try body()
        return data
    } catch {
        if logs {
            VHServiceLogger.log(error.localizedDescription, level: .error)
        }
        return nil
    }
}
