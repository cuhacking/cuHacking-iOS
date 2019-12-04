//
//  ScheduleViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit

enum ScheduleViewBuilder {
    static let colors: [UIColor] = [
        Asset.Colors.purpleEvent.color,
        Asset.Colors.blueEvent.color,
        Asset.Colors.redEvent.color,
        Asset.Colors.greenEvent.color
    ]
    enum Cells: String {
        case eventCell = "EventCell"
    }
    static func eventCell(events: [MagnetonAPIObject.Event], collectionView: UICollectionView, indexPath: IndexPath) -> EventCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.eventCell.rawValue, for: indexPath) as? EventCollectionViewCell else {
            fatalError("Could not find event cell")
        }
        let event = events[indexPath.row]
        cell.eventDetailsView.backgroundColor = ScheduleViewBuilder.colors[indexPath.row%ScheduleViewBuilder.colors.count]
        cell.eventTimeLabel.text = event.formattedStartTime
        cell.eventDetailsView.update(title: event.title,
                                     information: event.formattedDuration,
                                     buttonTitle: event.locationName,
                                     buttonIcon: Asset.Images.mapPinPoint.image)
        return cell
    }
}

class ScheduleViewController: UIViewController {
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.width, height: 10)
        return flowLayout
    }

    var collectionView: UICollectionView!
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
        view.backgroundColor =  Asset.Colors.background.color
        setupCollectionView()
        registerCells()
        loadEvents()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = Asset.Colors.background.color
        registerCells()
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }

    private func registerCells() {
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleViewBuilder.Cells.eventCell.rawValue)
         collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }

    private func loadEvents() {
        dataSource.getEvents { [weak self] (events, error) in
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
