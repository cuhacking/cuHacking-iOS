//
//  Theme.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
protocol Theme {
    static var tabBarTintColour : UIColor { get }
}

extension Theme {
     static var tabBarTintColour : UIColor {
        return UIColor(named: "CUPurple")!
    }
}
