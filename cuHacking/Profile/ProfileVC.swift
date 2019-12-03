//
//  ProfileVC.swift
//  cuHacking
//
//  Created by Santos on 2019-10-20.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
typealias PersonalInfoCell = ImageLabelView
typealias TeamInfoCell = ImageLabelSubtitleView

class ProfileVC: UIViewController {
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let tableView = UITableView()
    private let userInfo: [String] = []
    private let teamInfo: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        collectionView.backgroundColor = Asset.Colors.background.color
        view.addSubview(collectionView)
        collectionView.fillSuperview()

        collectionView.delegate = self
        collectionView.dataSource = self

        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 100)
        collectionViewFlowLayout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)

        collectionView.collectionViewLayout = collectionViewFlowLayout

        collectionView.register(PersonalInfoCell.self, forCellWithReuseIdentifier: "ImageLabelView")
        collectionView.register(TeamInfoCell.self, forCellWithReuseIdentifier: "TeamInfoCell")
        collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamInfoCell", for: indexPath) as? TeamInfoCell else {
//            return UICollectionViewCell()
//        }
//        cell.update(image: Asset.Images.blueQR.image, text: "Future", subText: "goat")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelView", for: indexPath) as? PersonalInfoCell else {
            return UICollectionViewCell()
        }
        cell.update(image: Asset.Images.blueQR.image, text: "Future")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        if kind == headerKind,
            let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView {
            switch indexPath.section {
            case 0:
                titleImageView.update(title: "Santos Gagbegnon", image: Asset.Images.sampleQR.image)
                return titleImageView
            default:
                break
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath)
    }
}
