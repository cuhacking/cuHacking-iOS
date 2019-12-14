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
import NetworkExtension

typealias InformationCell = InformationCollectionViewCell

class InformationViewController: CUCollectionViewController {

    override func registerCells() {
        super.registerCells()
        collectionView.register(InformationCell.self, forCellWithReuseIdentifier: InformationBuilder.Cells.informationCell.rawValue)
    }

    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
    }

//    @objc func connectToWifi() {
//        let hotSpotConfig = NEHotspotConfiguration(ssid: "HOME", passphrase: "cuhacking", isWEP: false)
//        NEHotspotConfigurationManager.shared.apply(hotSpotConfig) { (error) in
//            if let error = error {
//                print("failed:\(error)")
//            } else {
//                print("success")
//            }
//        }
//    }
}

extension InformationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return InformationBuilder.Info.infoCell(collectionView: collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader

        guard let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView else {
            fatalError("Title image view not found")
        }

        if kind == headerKind {
            titleImageView.update(title: "Information", image: nil)
        } else { titleImageView.update(title: nil, image: nil) }

        return titleImageView
    }
}
