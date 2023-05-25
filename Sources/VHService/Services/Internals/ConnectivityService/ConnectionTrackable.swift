//
//  ConnectionTrackable.swift
//
//
//  Created by Vidal HARA on 25.05.2023.
//
//

import Foundation

internal protocol ConnectionTrackable {

    func track(with delegate: TrackableDelegate)
    func start(queue: DispatchQueue)
    func stop()

    var connectivity: ConnectivityService.Status { get }
    var interface: ConnectivityService.Interface { get }
}

internal protocol TrackableDelegate: AnyObject {
    func trackerDidConnect(_ tracker: ConnectionTrackable)
    func trackerDidDisconnect(_ tracker: ConnectionTrackable)
}
