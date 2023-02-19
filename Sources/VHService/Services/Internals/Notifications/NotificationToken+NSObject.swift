//
//  NotificationToken+NSObject.swift
//  VHService
//
//  Created by Vidal HARA on 8.03.2020.
//  Copyright © 2020 Vidal HARA. All rights reserved.
//

import Foundation

internal extension NSObject {

    private struct AssociationKeys {
        static var notificationTokens = "ws_notificationTokens"
    }

    private func ws_setNotificationTokens(_ tokens: [NotificationToken]) {
        objc_setAssociatedObject(
            self, &AssociationKeys.notificationTokens, tokens, .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }

    func removeAllNotifications() {
        ws_setNotificationTokens([])
    }

    func addNotifications(_ tokens: [NotificationToken]) {
        if var notificationTokens = objc_getAssociatedObject(
            self, &AssociationKeys.notificationTokens
        ) as? [NotificationToken] {
            notificationTokens.append(contentsOf: tokens)
            ws_setNotificationTokens(notificationTokens)
        } else {
            ws_setNotificationTokens(tokens)
        }
    }

    func addNotifications(_ tokens: NotificationToken...) {
        addNotifications(tokens)
    }
}

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
