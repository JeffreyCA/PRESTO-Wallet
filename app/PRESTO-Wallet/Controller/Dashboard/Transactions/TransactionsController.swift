//
//  TransactionsController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-29.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import MZFormSheetPresentationController

class TransactionsController: ScrollingNavigationViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthView: MonthBar!

    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let navigationController = self.storyboard!.instantiateViewController(withIdentifier: "formSheetController") as? UINavigationController
        let filterOptionsController = navigationController?.viewControllers.first as? FilterOptionsTableViewController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController!)

        filterOptionsController?.delegate = self
        filterOptionsController?.filterOptions = filterOptions

        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.fade

        self.present(formSheetController, animated: true, completion: nil)
    }

    let amounts: [Double] = [-5.00, -7.50, -7.51, 20.00, -3.50]
    let dates: [String] = ["November 20, 2017", "November 22, 2017", "November 25, 2017", "November 28, 2017", "December 05, 2017"]
    let locations: [String] = ["Union Station", "Mount Joy GO", "Bloor/Yonge", "PRESTO", "St. Andrew"]

    var transactions: [Transaction] = []
    var visibleTransactions: [Transaction] = []
    var filterOptions: FilterOptions?

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY - hh:mm a"
        return formatter
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 0.0, followers: [NavigationBarFollower(view: monthView, direction: .scrollUp)])
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
        populateStubTransactions()
        sortTransactions()
    }

    private func populateStubTransactions() {
        let calendar = Calendar.current
        var transactionDate = Date()

        transactions.append(Transaction(agency: .GO, amount: 555.75, balance: 90.00, date: transactionDate, discount: 1.50, location: "Mount Joy GO"))
        transactionDate = calendar.date(byAdding: .day, value: -5, to: transactionDate)!
        transactions.append(Transaction(agency: .TTC, amount: -22.05, balance: 85.00, date: transactionDate, discount: 1.50, location: "St. Andrew Station"))
        transactionDate = calendar.date(byAdding: .day, value: -5, to: transactionDate)!
        transactions.append(Transaction(agency: .YRT_VIVA, amount: -3.99, balance: 90.00, date: transactionDate, discount: 1.50, location: "Unionville"))
        transactionDate = calendar.date(byAdding: .day, value: -5, to: transactionDate)!
        transactions.append(Transaction(agency: .PRESTO, amount: 0.99, balance: 90.00, date: transactionDate, discount: 1.50, location: "PRESTO"))

        visibleTransactions = transactions
    }

    private func sortTransactions() {
        transactions = transactions.sorted(by: { $0.date > $1.date })
    }

    private func applyFilter(_ filterOptions: FilterOptions?) {
        if let filterOptions = filterOptions {
            let agencies = filterOptions.agencies
            // Inclusive dates
            let startDate = filterOptions.startDate
            let endDate = filterOptions.endDate

            visibleTransactions = transactions.filter { (tx) -> Bool in
                let agency = agencies?.filter { $0.agency == tx.agency }

                // Only show transactions within filter date and if enabled agency
                if let result = agency?.first, let startDate = startDate, let endDate = endDate {
                    return tx.date.isBetween(startDate, endDate) && result.enabled
                }

                return false
            }
            print("Filtered")
        }
    }
}

extension TransactionsController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleTransactions.count
    }
}

extension TransactionsController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let transactionCell = cell as? TransactionsTableViewCell {
            let transaction = visibleTransactions[indexPath.row]
            transactionCell.amountLabel.text = transaction.amount.formattedAsCad
            transactionCell.dateLabel.text = TransactionsController.dateFormatter.string(from: transaction.date)
            transactionCell.locationLabel.text = transaction.location
            transactionCell.icon.image = UIImage(named: (transaction.agency.getImage()))
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false

            // Load more transactions, then stop spinner animating
            populateStubTransactions()
            tableView.reloadData()
        }
    }
}

extension TransactionsController: FilterOptionsDelegate {
    func updateFilterOptions(filterOptions: FilterOptions?) {
        self.filterOptions = filterOptions
        applyFilter(filterOptions)
        tableView.reloadData()
    }
}

extension TransactionsController: ScrollingNavigationControllerDelegate {
    func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState) {
        view.needsUpdateConstraints()
    }
}
