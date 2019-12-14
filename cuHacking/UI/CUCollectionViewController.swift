//
//  CUCollectionViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-12-14.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class CUCollectionViewController: UIViewController {
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.width, height: 10)
        return flowLayout
    }

    var collectionView: UICollectionView!
    let refreshController = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  Asset.Colors.background.color
        setupCollectionView()
    }

    func registerCells() {
        collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }

    @objc func refreshData() {}

    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = Asset.Colors.background.color
        registerCells()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.fillSuperview()

        collectionView.alwaysBounceVertical = true
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshController)
    }
}
