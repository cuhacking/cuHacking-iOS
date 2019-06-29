//
//  InformationViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-27.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class InformationViewController : CUViewController {
    override func viewDidLoad() {
        setupNavigationController()

    }
    
    private func setupNavigationController(){
        self.navigationController?.navigationBar.topItem?.title = "cuHacking"
        //Adding profile icon button to navigation bar
        let profileBarItem = UIBarButtonItem(image: UIImage(named: "ProfileIcon")!, style: .plain, target: self, action: #selector(showProfile))
        self.navigationItem.rightBarButtonItem = profileBarItem
        //Adding QR Scan icon to button navigation bar IF user is admin
        //TODO: Implement check for admin privelleges
        if (true) {
            let qrBarItem = UIBarButtonItem(image: UIImage(named: "QRIcon")!, style: .plain, target: self, action: #selector(showQRScanner))
            self.navigationItem.leftBarButtonItem = qrBarItem
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func showProfile(){
        let profileViewController = ProfileViewController()
        self.navigationController?.pushViewController(profileViewController, animated: false)
    }
    @objc func showQRScanner(){
        let qrScannerViewController = QRScannerViewController()
        navigationController?.pushViewController(qrScannerViewController, animated: false)
    }
}
