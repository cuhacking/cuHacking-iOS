//
//  InformationBuilder.swift
//  cuHacking
//
//  Created by Santos on 2019-12-08.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
enum InformationBuilder {
    enum Cells: String {
        case informationCell = "InfoCell"
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
}
