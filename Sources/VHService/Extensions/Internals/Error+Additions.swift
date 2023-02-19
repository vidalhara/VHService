//
//  Error+Additions.swift
//  VHService
//
//  Created by Vidal HARA on 11.05.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension Error {

    var ns: NSError { return self as NSError }

    var isCanceled: Bool { return ns.code == NSURLErrorCancelled }
}
