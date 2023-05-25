//
//  ConnectivityService.swift
//
//
//  Created by Vidal HARA on 25.05.2023.
//
//

import Foundation
import Network

internal final class ConnectivityService {

    static let shared = ConnectivityService()

    enum Status: String {
        case online, offline, notDetermined
    }

    enum Interface: String {
        case wifi, cellular, unavailable, notDetermined
    }

    var isConnected: Bool { status == .online }
    var isDisconnected: Bool { status == .offline }

    var interface: ConnectivityService.Interface { networkTracker.interface }
    private(set) var status: Status = .notDetermined

    private var _interface: ConnectivityService.Interface = .notDetermined
    private lazy var networkTracker: ConnectionTrackable = NWPathMonitor()

    private let queue: DispatchQueue

    public init() {
        self.queue = DispatchQueue(label: "com.vhservice.connectivityservice")
        self.start()
    }

    private func start() {
        networkTracker.start(queue: queue)
        networkTracker.track(with: self)
    }

    deinit {
        networkTracker.stop()
    }
}

// MARK: - TrackableDelegate

extension ConnectivityService: TrackableDelegate {

    func trackerDidConnect(_ tracker: ConnectionTrackable) {
        safeMainSync {
            self._interface = tracker.interface
            self.status = .online
        }
    }

    func trackerDidDisconnect(_ tracker: ConnectionTrackable) {
        safeMainSync {
            self._interface = tracker.interface
            self.status = .offline
        }
    }
}

private func safeMainSync(_ action: () -> Void) {
    if Thread.isMainThread {
        action()
    } else {
        DispatchQueue.main.sync(execute: action)
    }
}
