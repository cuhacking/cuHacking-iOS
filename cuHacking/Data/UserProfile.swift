//
//  UserProfile.swift
//  cuHacking
//
//  Created by Santos on 2019-11-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
struct MagnetonAPIObject {
    struct UserProfile: Codable {
        struct Data: Codable {
            let username: String
            let role: String
            let uid: String
        }

        let operation: String
        let status: String
        let data: Data
    }
}
