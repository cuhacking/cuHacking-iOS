//
//  InformationDomain.swift
//  cuHacking
//
//  Created by Santos on 2019-12-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
extension MagnetonAPIObject {
    struct Updates: Codable {
        let version: Int
        let updates: [String: Update]
        public var relevantUpdates: [Update] {
            let currentDate = Int64(Date().timeIntervalSince1970) * 1000
            let keys = Array(updates.keys).sorted(by: <).filter { (key) -> Bool in
                if let update = updates[key] {
                    return currentDate >= update.deliveryTime
                } else {
                    return false
                }
            }
            let relevantUpdates = keys.map { (key) -> Update in
                return updates[key]!
            }
            return relevantUpdates
        }
    }

    struct Update: Codable {
        let title: String
        let description: String
        let locationId: String
        let deliveryTime: Int
        let eventId: String
    }
}
