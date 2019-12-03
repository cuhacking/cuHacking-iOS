//
//  ScheduleViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class ScheduleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  Asset.Colors.background.color
        let titleView = TitleImageView(frame: .init(x: 50, y: 50, width: 200, height: 200))
        view.addSubview(titleView)
        titleView.update(title: "Santos", image: Asset.Images.qr.image)
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalToConstant: 200),
            titleView.widthAnchor.constraint(equalToConstant: 200),
            titleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
       

    }
}
