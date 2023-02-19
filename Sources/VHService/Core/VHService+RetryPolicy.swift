//
//  VHService+RetryPolicy.swift
//  VHService
//
//  Created by Vidal HARA on 11.05.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

public extension VHService {

    /// Policy to decide retring request or not
    enum RetryPolicy {
        /// Not retring request
        case doNotRetry

        /// Retring request
        case retry
    }
}
