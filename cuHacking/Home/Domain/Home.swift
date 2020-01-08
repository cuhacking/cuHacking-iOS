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
        let version: String
        let updates: [String: Update]
        public var relevantUpdates: [Update] {
            guard let currentDate = DateFormatter.RFC3339DateFormatter.date(from: DateFormatter.RFC3339DateFormatter.string(from: Date())) else {
                return []
            }
            let keys = Array(updates.keys).sorted(by: >).filter { (key) -> Bool in
                if let update = updates[key], let deliveryTime = update.formattedDeliveryTime {
                    return deliveryTime <= currentDate
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
        let name: String
        let location: String?
        let description: String
        let deliveryTime: String
        var formattedDeliveryTime: Date? {
            return DateFormatter.RFC3339DateFormatter.date(from: deliveryTime)
        }
    }
}
