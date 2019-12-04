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

typealias HeaderCell = TitleSubtitleCollectionViewCell
typealias OnboardingCell = InformationCollectionViewCell
typealias InformationCell = InformationCollectionViewCell
typealias UpdateCell = InformationCollectionViewCell

enum InformationViewBuilder {
    enum Cells: String {
        case headerCell = "HeaderCell"
        case informationCell = "InfoCell"
        case onboardingCell = "OnboardingCell"
        case updateCell = "UpdateCell"
    }
    enum Header {
        static func headerCell(collectionView: UICollectionView, indexPath: IndexPath) -> HeaderCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.headerCell.rawValue, for: indexPath) as? HeaderCell else {
                fatalError("Headercell was not found.")
            }
            cell.titleLabel.text = Strings.Information.HeaderCell.title
            return cell
        }
        static func onbaordingCell(collectionView: UICollectionView, indexPath: IndexPath) -> OnboardingCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.onboardingCell.rawValue, for: indexPath) as? OnboardingCell else {
                fatalError("Onboarding cell was not found")
            }
            cell.informationView.backgroundColor = Asset.Colors.surface.color
            cell.informationView.dropShadow()
            cell.informationView.titleLabel.textColor = Asset.Colors.primary.color
            //cell.informationView.isCentered = true
            cell.informationView.update(title: "Welcome to Local Hack Day!", information: "Before you begin your day, please make sure you are registered.")
            return cell
        }
    }
    enum Info {
        static func infoCell(collectionView: UICollectionView, indexPath: IndexPath) -> InformationCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.informationCell.rawValue, for: indexPath) as? InformationCell else {
                fatalError("InformationCell was not found.")
            }
            let wifiInfo = "Name: Local Hack Day\nPassword: cuhacking"
            cell.informationView.titleLabel.textColor = .black
            cell.informationView.informationTextView.textColor = .black
            cell.informationView.update(title: "Wifi Info", information: wifiInfo, buttonTitle: nil)
            return cell
        }
    }
    enum Announcements {
        static func updateCell(updates: [MagnetonAPIObject.Update] ,collectionView: UICollectionView, indexPath: IndexPath) -> UpdateCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.updateCell.rawValue, for: indexPath) as? UpdateCell else {
                fatalError("Update cell wsa not found.")
            }
            let update = updates[indexPath.row]
            cell.informationView.backgroundColor = Asset.Colors.surface.color
            cell.informationView.dropShadow()
            cell.informationView.update(title: update.title, information: update.description, buttonTitle: nil)
            return cell
        }
    }
}

class InformationViewController: UIViewController {
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        flowLayout.estimatedItemSize = CGSize(width: view.bounds.width, height: 10)
        return flowLayout
    }

    var collectionView: UICollectionView!
    private var updates: [MagnetonAPIObject.Update]?
    private var dataSource: InformationRepository
    private let refreshController = UIRefreshControl()

    init(dataSource: InformationRepository = InformationDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationController()
        loadUpdates()
    }

    private func registerCells() {
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: InformationViewBuilder.Cells.onboardingCell.rawValue)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: InformationViewBuilder.Cells.headerCell.rawValue)
        collectionView.register(InformationCell.self, forCellWithReuseIdentifier: InformationViewBuilder.Cells.informationCell.rawValue)
        collectionView.register(UpdateCell.self, forCellWithReuseIdentifier: InformationViewBuilder.Cells.updateCell.rawValue)
        collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }

    private func createCrashButton() {
        let crashButton = UIButton(frame: CGRect(x: 20, y: 100, width: 100, height: 50))
        crashButton.addTarget(self, action: #selector(crashApp), for: .touchUpInside)
        crashButton.setTitle("Crash!", for: .normal)
        crashButton.backgroundColor = .red
        crashButton.layer.cornerRadius = 4
        self.view.addSubview(crashButton)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = Asset.Colors.background.color
        registerCells()
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.alwaysBounceVertical = true
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshController)
    }

    private func loadUpdates() {
        InformationDataSource().getUpdates { [weak self] (updates, error) in
            DispatchQueue.main.async {
               if self?.refreshController.isRefreshing == true {
                   self?.refreshController.endRefreshing()
               }
            }
            if error != nil {
                print(error)
                return
            }
            guard let updates = updates else {
                print("Failed to get updates")
                return
            }
            self?.updates = updates.relevantUpdates
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    @objc func crashApp() {
        Crashlytics.sharedInstance().crash()
    }

    @objc func showSettings() {
        let settingsViewController = SettingsViewController()
//        let profileViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
        self.navigationController?.pushViewController(settingsViewController, animated: false)
    }

    @objc func showQRScanner() {
        let qrScannerViewController = QRScannerViewController()
        navigationController?.pushViewController(qrScannerViewController, animated: false)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return updates?.count ?? 0
        default:
            fatalError("Too many sections")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: // Header Section
            switch indexPath.row {
            case 0:
                return InformationViewBuilder.Header.headerCell(collectionView: collectionView, indexPath: indexPath)
            case 1:
                return InformationViewBuilder.Header.onbaordingCell(collectionView: collectionView, indexPath: indexPath)
            default:
                fatalError("Row out of range")
            }
        case 1: //Info section
            return InformationViewBuilder.Info.infoCell(collectionView: collectionView, indexPath: indexPath)
        case 2:
            guard let updates = updates else {
                fatalError("No udpates")
            }
            return InformationViewBuilder.Announcements.updateCell(updates: updates, collectionView: collectionView, indexPath: indexPath)
        default:
            fatalError("Section out of range")
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader

        if kind == headerKind,
            let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView {
            switch indexPath.section {
            case 1:
                titleImageView.update(title: "Info", image: nil)
                return titleImageView
            case 2:
                titleImageView.update(title: "Announcements", image: nil)
                return titleImageView
            default:
                break
            }
        }
        guard let titleImageView = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: "TitleImageView", for: indexPath) as? TitleImageView else {
            fatalError("Title image view not found")
        }
        titleImageView.update(title: nil, image: nil)
        return titleImageView
    }
}

extension InformationViewController {
    @objc func refreshData() {
        refreshController.beginRefreshing()
        loadUpdates()
    }
    private func setupNavigationController() {
        self.navigationController?.navigationBar.topItem?.title = "cuHacking"
        self.navigationController?.navigationBar.tintColor = Asset.Colors.primaryText.color
        //Adding profile icon button to navigation bar
        let settingsIconBar = UIBarButtonItem(image: Asset.Images.settingsIcon.image, style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.rightBarButtonItem = settingsIconBar
        //Adding QR Scan icon to button navigation bar IF user is admin
        //let qrBarItem = UIBarButtonItem(image: Asset.Images.qrIcon.image, style: .plain, target: self, action: #selector(showQRScanner))
        //self.navigationItem.leftBarButtonItem = qrBarItem
    }
}
