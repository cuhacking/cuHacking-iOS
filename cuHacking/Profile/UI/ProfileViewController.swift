//
//  ProfileViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-10-20.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
typealias PersonalInfoCell = ImageLabelView
typealias TeamInfoCell = ImageLabelSubtitleView

class ProfileViewController: UIViewController {
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let tableView = UITableView()
    private let userInfo: [String] = []
    private let teamInfo: [String] = []
    private let profileName: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: Fonts.ReemKufi.regular, size: 18)
        label.text = "santosgagbegnon@gmail.com"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = "santosgagbegnon@gmail.com".qrCode
        return imageView
    }()
    
    private let dataSource: ProfileRepository

    init(dataSource: ProfileRepository = ProfileDataSource()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationController()
        if let token = UserSession.current.token?.token {
            dataSource.getUserProfile(token: token) { (profile, error) in
        
            }
        }
    }

    private func setup() {
        view.backgroundColor = Asset.Colors.background.color
        collectionView.backgroundColor = Asset.Colors.background.color
        view.addSubviews(views: profileName, qrImageView, collectionView)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileName.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),

            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            qrImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            qrImageView.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 16),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])

        collectionView.delegate = self
        collectionView.dataSource = self

        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 20)
        collectionViewFlowLayout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)

        collectionView.collectionViewLayout = collectionViewFlowLayout

        collectionView.register(PersonalInfoCell.self, forCellWithReuseIdentifier: "ImageLabelView")
        collectionView.register(TeamInfoCell.self, forCellWithReuseIdentifier: "TeamInfoCell")
        collectionView.register(TitleImageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleImageView")
    }

    private func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = Asset.Colors.primaryText.color

        //Adding QR Scan icon to button navigation bar IF user is admin
        let settingsIconBar = UIBarButtonItem(image: Asset.Images.settingsIcon.image, style: .plain, target: self, action: #selector(showSettings))
        let qrBarItem = UIBarButtonItem(image: Asset.Images.qrIcon.image, style: .plain, target: self, action: #selector(showQRScanner))
        self.navigationItem.rightBarButtonItems = [qrBarItem, settingsIconBar]
    }

    @objc func showQRScanner() {
        let qrScannerViewController = QRScannerViewController()
        navigationController?.pushViewController(qrScannerViewController, animated: false)
    }

    @objc func showSettings() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: false)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelView", for: indexPath) as? PersonalInfoCell else {
            return UICollectionViewCell()
        }
        cell.update(image: Asset.Images.blueQR.image, text: "Information")
        return cell
    }
}
