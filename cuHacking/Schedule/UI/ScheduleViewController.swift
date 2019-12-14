//
//  ScheduleViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit

class ScheduleViewController: CUCollectionViewController {
    var events: [MagnetonAPIObject.Event]?
    private let dataSource: ScheduleRepository

    init(dataSource: ScheduleRepository = ScheduleDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        loadEvents()
    }

    override func setupCollectionView() {
        super.setupCollectionView()
        collectionView.dataSource = self
    }

    override func registerCells() {
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleViewBuilder.Cells.eventCell.rawValue)
         collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }

    private func loadEvents() {
        dataSource.getEvents { [weak self] (events, error) in
            DispatchQueue.main.async {
               if self?.refreshController.isRefreshing == true {
                   self?.refreshController.endRefreshing()
               }
            }
            if error != nil {
                print(error)
                return
            }
            guard let events = events else {
                print("Failed to get events")
                return
            }
            self?.events = events.orderedEvents
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func refreshData() {
        refreshController.beginRefreshing()
        loadEvents()
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let events = events else {
            fatalError("No events")
        }
        return ScheduleViewBuilder.eventCell(events: events, collectionView: collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader

        if kind == headerKind,
            let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView {
            titleImageView.update(title: "Saturday, December 7th", image: nil)
            return titleImageView
        }
        guard let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView else {
            fatalError("Title image view not found")
        }
        titleImageView.update(title: nil, image: nil)
        return titleImageView
    }
}
