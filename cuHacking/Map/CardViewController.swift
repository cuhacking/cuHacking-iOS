//
//  CardViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-07-30.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class CardViewController : UIViewController {
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = UIFont.systemFont(ofSize: 45, weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    override func loadView() {
        let view = CardView()
        self.view = view
    }
    override func viewDidLoad() {
        setupLabel()
    }
    func setupLabel(){
        self.view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: -10) )
    }
}

