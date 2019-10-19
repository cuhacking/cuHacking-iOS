//
//  CUTextField.swift
//  cuHacking
//
//  Created by Santos on 2019-09-02.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class CUTextField : UITextField{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderStyle = .roundedRect
        self.layer.borderColor = UIColor(named: "CUAnyBlack")?.cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
    }
}
