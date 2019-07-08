//
//  SettingsViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class SettingsViewController : CUViewController {
    override func viewDidLoad() {
        setupNavigationController()
        super.viewDidLoad()
    }
    func setupNavigationController(){
        self.title = "Settings"
    }
}
