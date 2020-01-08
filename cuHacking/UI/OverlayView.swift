//
//  OverlayView.swift
//  cuHacking
//
//  Created by Santos on 2020-01-04.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
final class OverlayView: UIView {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
