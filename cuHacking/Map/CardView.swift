//
//  CardView.swift
//  cuHacking
//
//  Created by Santos on 2019-07-30.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit

class CardView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
        backgroundColor =  Asset.Colors.white.color
    }
}
