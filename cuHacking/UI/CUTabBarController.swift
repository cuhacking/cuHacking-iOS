//
//  CUTabBarController.swift
//  cuHacking
//
//  This is the central tab bar seen throughout the applications.
//
//  Created by Santos on 2019-06-27.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class CUTabBarController : UITabBarController {
    override func viewDidLoad() {
        //First tab - Information VC
        let informationViewController = InformationViewController()
        let navigationController = UINavigationController(rootViewController: informationViewController)
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "HomeIcon")!, tag: 0)
        
        //Second tab - Schedule VC
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(named: "ScheduleIcon")!, tag: 1)
        
        //Third tab - Map vc
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "MapIcon")!, tag: 2)
       
        //Setting view controllers
        viewControllers = [navigationController, scheduleViewController, mapViewController]
    }
}

