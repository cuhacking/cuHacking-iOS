//
//  Theme.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
protocol Theme {
    var navigationBarStyle : UIBarStyle { get }
    var navigationTitleColour : UIColor { get }
    var barButtonTint : UIColor { get }
    var tabBarTint : UIColor { get }
    var labelTextColour : UIColor { get }
    var backgroundColour : UIColor { get }
    var cardBackground : UIColor { get }
}

extension Theme {
    var tabBarTint : UIColor {
        return UIColor(named: "CUPurple")!
    }
    
    func apply(toAppplication application : UIApplication){
        UINavigationBar.appearance().barStyle = navigationBarStyle
        UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: navigationTitleColour]
        UIBarButtonItem.appearance().tintColor = barButtonTint
        UITabBar.appearance().tintColor = tabBarTint
        CUView.appearance().backgroundColor = backgroundColour
        CardView.appearance().backgroundColor = backgroundColour

        UILabel.appearance().textColor = labelTextColour
//        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor.red], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor.orange], for: .selected)
    }
}
