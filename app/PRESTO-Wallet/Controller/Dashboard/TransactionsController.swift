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

    var transactions: [Transaction] = []

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
        populateTransactions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func populateTransactions() {
        transactions.append(Transaction(agency: .GO, amount: -5.75, balance: 90.00, date: Date(), discount: 1.50, location: "Mount Joy GO"))
        transactions.append(Transaction(agency: .TTC, amount: -2.05, balance: 85.00, date: Date(), discount: 1.50, location: "St. Andrew Station"))
        transactions.append(Transaction(agency: .YRT_VIVA, amount: -3.99, balance: 90.00, date: Date(), discount: 1.50, location: "Unionville"))
        transactions.append(Transaction(agency: .PRESTO, amount: 0.99, balance: 90.00, date: Date(), discount: 1.50, location: "PRESTO"))
    }
}

extension TransactionsController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
}

extension TransactionsController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d - h:mm a"

        if let transactionCell = cell as? TransactionsTableViewCell {
            let transaction = transactions[indexPath.row]
            transactionCell.amountLabel.text = transaction.amount.formattedAsCad
            transactionCell.dateLabel.text = dateFormatter.string(from: transaction.date)
            transactionCell.locationLabel.text = transaction.location
            transactionCell.icon.image = UIImage(named: (transaction.agency.getImage()))
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TransactionsController: ScrollingNavigationControllerDelegate {
    func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState) {
        view.needsUpdateConstraints()
    }
}
