//
//  NWPathMonitor+ConnectionTrackable.swift
//
//
//  Created by Vidal HARA on 25.05.2023.
//
//

import Foundation
import Network

extension NWPathMonitor: ConnectionTrackable {

    func track(with delegate: TrackableDelegate) {

        pathUpdateHandler = { [weak delegate, unowned self] path in
            switch path.status {
            case .satisfied:
                delegate?.trackerDidConnect(self)

            case .unsatisfied:
                delegate?.trackerDidDisconnect(self)

            case .requiresConnection:
                break

            @unknown
            default:
                break
            }
        }
    }

    var connectivity: ConnectivityService.Status {
        switch currentPath.status {
        case .satisfied:
            return .online
        case .requiresConnection, .unsatisfied:
            return .offline
        @unknown
        default:
            return .offline
        }
    }

    var interface: ConnectivityService.Interface {
        if currentPath.usesInterfaceType(.wifi) {
            return .wifi
        } else if currentPath.usesInterfaceType(.cellular) {
            return .cellular
        } else {
            return .unavailable
        }
    }

    func stop() {
        cancel()
    }
}

