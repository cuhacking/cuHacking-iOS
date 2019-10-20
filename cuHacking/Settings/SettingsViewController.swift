//
//  SettingsViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        view.backgroundColor = Palette.white.color
    }
    
    func setupNavigationController() {
        self.title = "Settings"
    }
}
