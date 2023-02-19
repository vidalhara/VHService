//
//  Result+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 11.05.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension Result where Failure == Error {

    init(_ success: Success?, _ error: Failure? = nil) {

        if let success = success, error == nil {
            self = .success(success)
        }
        else {
            self = .init(error: error)
        }
    }

    init(error: Failure?) {
        self = .failure(error.ifNil(VHServiceError.unknown))
    }

    var item: Success? {
        switch self {
        case .success(let item):
            return item

        case .failure:
            return .none
        }
    }

    func compactMap<T>(_ action: (Success) -> T?) -> Result<T, Failure> {
        switch self {
        case .success(let success):
            return .init(action(success), nil)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
