//
//  InformationViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-27.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class InformationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        setupNavigationController()
        createCrashButton()
    }

    private func createCrashButton() {
        let crashButton = UIButton(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        crashButton.addTarget(self, action: #selector(crashApp), for: .touchUpInside)
        crashButton.setTitle("Crash!", for: .normal)
        crashButton.backgroundColor = .red
        crashButton.layer.cornerRadius = 4
        self.view.addSubview(crashButton)
    }

    private func setupNavigationController() {
        self.navigationController?.navigationBar.topItem?.title = "cuHacking"
        //Adding profile icon button to navigation bar
        let profileBarItem = UIBarButtonItem(image: UIImage(named: "ProfileIcon")!, style: .plain, target: self, action: #selector(showProfile))
        self.navigationItem.rightBarButtonItem = profileBarItem
        //Adding QR Scan icon to button navigation bar IF user is admin
        //TODO: Implement check for admin privelleges
        let qrBarItem = UIBarButtonItem(image: UIImage(named: "QRIcon")!, style: .plain, target: self, action: #selector(showQRScanner))
        self.navigationItem.leftBarButtonItem = qrBarItem
    }

    @objc func crashApp() {
        Crashlytics.sharedInstance().crash()
    }

    @objc func showProfile() {
        print("showing profile")
        let profileViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
        self.navigationController?.pushViewController(profileViewController, animated: false)
    }

    @objc func showQRScanner() {
        let qrScannerViewController = QRScannerViewController()
        navigationController?.pushViewController(qrScannerViewController, animated: false)
    }
}
