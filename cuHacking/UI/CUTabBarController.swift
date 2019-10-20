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
class CUTabBarController: UITabBarController {
    override func viewDidLoad() {
        //First tab - Information VC
        let informationViewController = InformationViewController()
        let navigationController = UINavigationController(rootViewController: informationViewController)
        navigationController.navigationBar.tintColor =  Asset.Colors.gray.color
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: Asset.Images.homeIcon.image, tag: 0)

        //Second tab - Schedule VC
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.tabBarItem = UITabBarItem(title: "Schedule", image: Asset.Images.scheduleIcon.image, tag: 1)

        //Third tab - Map vc
        let viewModel = MapViewModel(mapDataSource: MapDataSource())
        let mapViewController = MapViewController(viewModel: viewModel!)
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: Asset.Images.mapIcon.image, tag: 2)

        //Setting view controllers
        viewControllers = [navigationController, scheduleViewController, mapViewController]
        tabBar.tintColor =  Asset.Colors.purple.color
        tabBar.unselectedItemTintColor =  Asset.Colors.gray.color
    }
}
