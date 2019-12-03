////
////  ImageLabelCell.swift
////  cuHacking
////
////  Created by Santos on 2019-10-20.
////  Copyright © 2019 cuHacking. All rights reserved.
////
//
import UIKit
class ImageLabelView: UICollectionViewCell {
    private let imageView = UIImageView()
    private let label = UILabel()

    var text: String? {
        didSet {
            label.text = text
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubviews(views: imageView, label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),

            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    func update(image: UIImage, text: String) {
        self.image = image
        self.text = text
    }
}
