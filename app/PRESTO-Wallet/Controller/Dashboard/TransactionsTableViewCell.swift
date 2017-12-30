//
//  TransactionsTableViewCell.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey Chen on 2017-12-29.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
