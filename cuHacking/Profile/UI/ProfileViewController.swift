//
//  ProfileViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
class ProfileViewController: CUViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        //YOU section
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else {
                fatalError("Could no create Info Cell")
            }
            //Food Group
            if indexPath.row == 0 {
                cell.iconImage.layer.cornerRadius = cell.iconImage.frame.width/2
                cell.iconImage.backgroundColor = .blue
                cell.informationLabel.text = "Blue Group"
            //Program
            } else if indexPath.row == 1 {
                cell.iconImage.image = UIImage(named: "Grad")
                cell.informationLabel.text = "University of Ottawa"
            }
            //Email
            else {
                cell.iconImage.image = UIImage(named: "Mail")
                cell.informationLabel.text = "janedoe@gmail.com"
            }
            return cell
        } else {
        //TEAM Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamCell else {
                fatalError("Cell TYPE")
            }
            if indexPath.row == 0 {
                cell.profileImage.image = UIImage(named: "redQR")
                cell.teamMemberLabel.text = "Jessica"
                cell.positionLabel.text = "Developer"
            } else if indexPath.row == 1 {
                cell.profileImage.image = UIImage(named: "blueQR")
                cell.teamMemberLabel.text = "Joshua"
                cell.positionLabel.text = "Designer"
            } else if indexPath.row == 2 {
                cell.profileImage.image = UIImage(named: "greenQR")
                cell.teamMemberLabel.text = "Jackson"
                cell.positionLabel.text = "Designer"
            } else if indexPath.row == 3 {
                cell.profileImage.image = UIImage(named: "pinkQR")
                cell.teamMemberLabel.text = "Jeremy"
                cell.positionLabel.text = "Developer"
            }
            return cell
        }
    }

    @IBOutlet weak var profileInformationTableView: UITableView!

    override func viewDidLoad() {
        setupNavigationController()

        profileInformationTableView.separatorStyle = .none
        profileInformationTableView.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        profileInformationTableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        profileInformationTableView.delegate = self
        profileInformationTableView.separatorStyle = .singleLine
        profileInformationTableView.dataSource = self
        super.viewDidLoad()
    }

    func setupNavigationController() {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        self.navigationController?.navigationBar.tintColor = .black
        let settingsBarbutton = UIBarButtonItem(image: UIImage(named: "SettingsIcon")!, style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.rightBarButtonItem = settingsBarbutton
    }

    @objc func showSettings() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 60
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backgroundView = UIView()
        let label = UILabel()
        backgroundView.addSubview(label)
         label.anchor(top: backgroundView.topAnchor, leading: backgroundView.leadingAnchor, bottom: backgroundView.bottomAnchor, trailing: backgroundView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -50))
        if section == 0 {
            label.text = "You"
        } else {
            label.text = "Team"
            let addTeam = UIButton()
            backgroundView.addSubview(addTeam)
            if #available(iOS 13.0, *) {
                addTeam.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
                addTeam.tintColor = UIColor.black
            } else {
                // Fallback image
                addTeam.tintColor = UIColor.white
            }
            addTeam.anchor(top: backgroundView.topAnchor, leading: label.trailingAnchor, bottom: backgroundView.bottomAnchor, trailing: backgroundView.trailingAnchor, padding: .init(top:0, left: -20, bottom:0, right: 0))
        }
        label.font = .systemFont(ofSize: 28, weight: .medium)
        backgroundView.backgroundColor = UIColor(named: "CUWhite")
        return backgroundView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        default:
            break
        }
        return 1
    }
}
