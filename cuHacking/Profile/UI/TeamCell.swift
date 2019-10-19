//
//  TeamCell.swift
//  cuHacking
//
//  Created by Santos on 2019-08-22.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var teamMemberLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
