//
//  NotificationToken+NSObject.swift
//  VHService
//
//  Created by Vidal HARA on 8.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension NotificationCenter {

    @discardableResult
    func observe(
        name: Notification.Name,
        object: Any? = nil,
        queue: OperationQueue = .main,
        using block: @escaping (Notification) -> Void
    ) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}
