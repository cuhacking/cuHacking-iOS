//
//  SystemTheme.swift
//  cuHacking
//
//  Created by Santos on 2019-07-03.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
@available(iOS 13.0, *)
struct SystemTheme : Theme {
    var backgroundColour: UIColor = .systemBackground
    var navigationTitleColour: UIColor = .label
    var barButtonTint: UIColor = UIColor(named: "CUBlack")!
    var navigationBarStyle: UIBarStyle = .default
    var labelTextColour: UIColor = .label
    var cardBackground: UIColor = .systemBackground

}
