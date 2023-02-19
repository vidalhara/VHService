//
//  NotificationToken.swift
//  VHService
//
//  Created by Vidal HARA on 8.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal final class NotificationToken: NSObject {

    internal let notificationCenter: NotificationCenter
    internal let token: Any

    internal init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}
