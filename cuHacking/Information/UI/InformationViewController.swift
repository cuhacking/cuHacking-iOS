//
//  InformationViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-27.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class InformationViewController : UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupNavigationController()
    }
    
    private func setupNavigationController(){
        self.navigationController?.navigationBar.topItem?.title = "cuHacking"
        let profileBarItem = UIBarButtonItem(image: UIImage(named: "ProfileIcon")!, style: .plain, target: self, action: #selector(showProfile))
        self.navigationItem.rightBarButtonItem = profileBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    @objc func showProfile(){
      
    }
}
