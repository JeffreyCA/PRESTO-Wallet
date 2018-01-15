//
//  SelectTransitAgencyTableViewCell.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-07.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit

class SelectTransitAgencyTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
