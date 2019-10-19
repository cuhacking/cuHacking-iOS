//
//  Int+Ext.swift
//  cuHacking
//
//  Created by Santos on 2019-07-29.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
extension Int {
    func toLevel() -> Level {
        switch self {
        case 1:
            return .one
        case 2:
            return .two
        case 3:
            return .three
        default:
            return .one
        }
    }
}
