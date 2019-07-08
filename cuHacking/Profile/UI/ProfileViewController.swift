//
//  ProfileViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class ProfileViewController : CUViewController {
    override func viewDidLoad() {
        setupNavigationController()
        super.viewDidLoad()
    }
    func setupNavigationController(){
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        self.navigationController?.navigationBar.tintColor = .black
        let settingsBarbutton = UIBarButtonItem(image: UIImage(named: "SettingsIcon")!, style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.rightBarButtonItem = settingsBarbutton
    }
    @objc func showSettings(){
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: false)
    }
}
