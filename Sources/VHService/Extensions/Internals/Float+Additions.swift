//
//  Float+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 25.04.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import UIKit

// MARK: - FloatingPoint

infix operator ^/ : MultiplicationPrecedence

internal extension FloatingPoint {

    static func ^/ (lhs: Self, rhs: Self) -> Self {
        if rhs == 0 { return 0 }
        return lhs / rhs
    }
}

// MARK: - Int64

internal extension Int64 {

    var cg: CGFloat {
        return CGFloat(self)
    }
}
