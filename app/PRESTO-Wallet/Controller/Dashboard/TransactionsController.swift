//
//  TransactionsController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-29.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class TransactionsController: ScrollingNavigationViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthView: MonthBar!

    let amounts: [Double] = [-5.00, -7.50, -7.51, 20.00, -3.50]
    let dates: [String] = ["November 20, 2017", "November 22, 2017", "November 25, 2017", "November 28, 2017", "December 05, 2017"]
    let locations: [String] = ["Union Station", "Mount Joy GO", "Bloor/Yonge", "PRESTO", "St. Andrew"]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 0.0, followers: [monthView])
            navigationController.scrollingNavbarDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.contentInset = UIEdgeInsets(top: monthView.frame.height, left: 0, bottom: 100, right: 0)

        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.frame = monthView.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.layer.zPosition = -1
        monthView.addSubview(visualEffectView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TransactionsController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension TransactionsController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let transactionCell = cell as? TransactionsTableViewCell {
            transactionCell.amountLabel.text = amounts[indexPath.row].formattedAsCad
            transactionCell.dateLabel.text = dates[indexPath.row]
            transactionCell.locationLabel.text = locations[indexPath.row]
            transactionCell.icon.image = UIImage(named: "presto_green")
        }

        return cell
    }
}

extension TransactionsController: ScrollingNavigationControllerDelegate {
    func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState) {
        view.needsUpdateConstraints()
    }
}
