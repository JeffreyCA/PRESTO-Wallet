//
//  TransactionsTableViewCell.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-29.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var agencyLabel: UILabel!
    @IBOutlet weak var discountTextLabel: UILabel!
    @IBOutlet weak var discountAmountLabel: UILabel!

    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!

    private enum Constants {
        static let EXPANDED_MIDDLE_CONSTRAINT: CGFloat = 15
        static let DISCOUNT_LABEL_TEXT: String = "Discount:"
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 10.0, *) {
            locationLabel.adjustsFontSizeToFitWidth = true
            dateLabel.adjustsFontSizeToFitWidth = true
            amountLabel.adjustsFontSizeToFitWidth = true
            agencyLabel.adjustsFontSizeToFitWidth = true
            discountAmountLabel.adjustsFontSizeToFitWidth = true
            discountTextLabel.adjustsFontSizeToFitWidth = true
        }
    }

    func cellSelected(content: Transaction) {
        if content.expanded {
            self.agencyLabel.text = content.agency.rawValue
            self.discountAmountLabel.text = content.discount.formattedAsCad
            self.discountTextLabel.text = Constants.DISCOUNT_LABEL_TEXT
            self.middleConstraint.constant = Constants.EXPANDED_MIDDLE_CONSTRAINT
        } else {
            self.agencyLabel.text = ""
            self.discountAmountLabel.text = ""
            self.discountTextLabel.text = ""
            self.middleConstraint.constant = 0
        }
        self.updateConstraints()
    }
}
