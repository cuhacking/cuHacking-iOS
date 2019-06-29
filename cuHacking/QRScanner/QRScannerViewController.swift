//
//  QRScannerViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class QRScannerViewController : CUViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.makeTransparent()
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.undoTransparent()
        super.viewWillAppear(animated)
    }
}
