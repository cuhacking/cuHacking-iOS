//
//  Schedule.swift
//  cuHacking
//
//  Created by Santos on 2019-12-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//
import Foundation

extension MagnetonAPIObject {
    struct Events: Codable {
        let version: Int
        let events: [String: Event]
        public var orderedEvents: [Event] {
            let keys = Array(events.keys).sorted(by: <)
            return keys.map { (key) -> Event in
                return events[key]!
            }
        }
    }
    struct Event: Codable {
        let locationName: String
        let locationId: String
        let title: String
        let description: String
        let startTime: Int
        let endTime: Int
        let type: String
        var formattedStartTime: String {
            let date = Date(timeIntervalSince1970: Double(startTime/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.string(from: date)
        }
        var formattedEndTime: String {
            let date = Date(timeIntervalSince1970: Double(endTime/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.string(from: date)
        }
        var formattedDuration: String {
            return "\(formattedStartTime) - \(formattedEndTime)"
        }
    }
}
