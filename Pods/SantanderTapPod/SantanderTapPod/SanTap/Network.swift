//
//  Network.swift
//  Teclado
//
//  Created by Darshan Bagmar on 08/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation

struct Network {
    static var reachability: Reachability!
    enum Status: String {
        case unreachable, wifi, wwan
    }
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}
