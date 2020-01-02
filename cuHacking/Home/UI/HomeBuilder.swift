//
//  HomeBuilder.swift
//  cuHacking
//
//  Created by Santos on 2019-12-14.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
enum HomeBuilder {
    enum Cells: String {
        case headerCell = "HeaderCell"
        case onboardingCell = "OnboardingCell"
        case updateCell = "UpdateCell"
    }

    enum Header {
        static func headerCell(collectionView: UICollectionView, indexPath: IndexPath) -> HeaderCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.headerCell.rawValue, for: indexPath) as? HeaderCell else {
                fatalError("Headercell was not found.")
            }
            print("started")
            let hackathonDate = Date(timeIntervalSince1970: 1578725761).timeIntervalSince1970 - Date().timeIntervalSince1970
            cell.startCountdown(from: hackathonDate, withMessage: "Hacking starts in", completedMessage: "Hacking has begun!")
            return cell
        }
        static func onbaordingCell(collectionView: UICollectionView, indexPath: IndexPath) -> OnboardingCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.onboardingCell.rawValue, for: indexPath) as? OnboardingCell else {
                fatalError("Onboarding cell was not found")
            }
            cell.informationView.backgroundColor = Asset.Colors.surface.color
            cell.informationView.dropShadow()
            cell.informationView.titleLabel.textColor = Asset.Colors.primary.color
            cell.informationView.isCentered = true
            cell.informationView.update(title: "Welcome to cuHacking 2020!", information: "Before you begin your day, please make sure you are registered.")
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
