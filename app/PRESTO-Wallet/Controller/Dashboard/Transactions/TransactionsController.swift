//
//  TransactionsController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-29.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit
import Alamofire
import AMScrollingNavbar
import MZFormSheetPresentationController

class TransactionsController: ScrollingNavigationViewController {
    @IBOutlet weak var tableView: UITableView!

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
    var indicator = UIActivityIndicatorView()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY - hh:mm a"
        return formatter
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
            navigationController.shouldUpdateContentInset = false
            navigationController.scrollingNavbarDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.layer.zPosition = -1

        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)

        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        populateRealTransactions()

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func populateStubTransactions() {
        let calendar = Calendar.current
        var transactionDate = Date()

        for _ in 1...5 {
            transactions.append(Transaction(agency: .GO, amount: 555.75, balance: 90.00, date: transactionDate, discount: 1.50, location: "Mount Joy GO", type: "", serviceClass: ""))
            transactionDate = calendar.date(byAdding: .day, value: -5, to: transactionDate)!
            transactions.append(Transaction(agency: .TTC, amount: -22.05, balance: 85.00, date: transactionDate, discount: 1.50, location: "St. Andrew Station", type: "", serviceClass: ""))
            transactionDate = calendar.date(byAdding: .day, value: -5, to: transactionDate)!
            transactions.append(Transaction(agency: .YRT_VIVA, amount: -3.99, balance: 90.00, date: transactionDate, discount: 1.50, location: "Unionville", type: "", serviceClass: ""))
            transactionDate = calendar.date(byAdding: .day, value: -5, to: transactionDate)!
            transactions.append(Transaction(agency: .PRESTO, amount: 0.99, balance: 90.00, date: transactionDate, discount: 1.50, location: "Top Up", type: "", serviceClass: ""))
        }
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
        }
    }
}

extension TransactionsController {
    func jsonToDict(jsonData: String) throws -> [String: Any]? {
        return try JSONSerialization.jsonObject(with: jsonData.data(using: .utf8)!, options: []) as? [String: Any]
    }

    func parseResponse(responseString: String) -> [Transaction] {
        var transactions: [Transaction] = []
        var firstLine = true

        responseString.enumerateLines { line, _ in
            let splitLine = line.replacingOccurrences(of: "\"", with: "").components(separatedBy: ",")

            if firstLine {
                firstLine = false
                return
            }

            transactions.append(Transaction(csvData: splitLine))
        }

        return transactions
    }

    func populateRealTransactions() {
        let path = Bundle.main.path(forResource: "config", ofType: "json")

        guard let jsonPath = path else {
            return
        }

        do {
            let jsonData = try String(contentsOfFile: jsonPath, encoding: String.Encoding.utf8)
            let dictData = try jsonToDict(jsonData: jsonData)

            Alamofire.request(APIConstant.BASE_URL + APIConstant.DASHBOARD_CARD_ACTIVITY_PATH, method: .get, encoding: JSONEncoding.default, headers: nil).responseString { _ in
                Alamofire.request(APIConstant.BASE_URL + APIConstant.DASHBOARD_CARD_ACTIVITY_FILTERED_PATH, method: .post,
                                  parameters: dictData, encoding: JSONEncoding.default, headers: nil).responseString { _ in

                                    // Set .csv destination
                                    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                        documentsURL.appendPathComponent("transactions.csv")
                                        return (documentsURL, [.removePreviousFile])
                                    }

                                    // Download .csv transactions file
                                    Alamofire.download(APIConstant.BASE_URL + APIConstant.TRANSACTION_CSV_PATH, to: destination).responseString { response in
                                        self.transactions = self.parseResponse(responseString: response.description)
                                        self.visibleTransactions = self.transactions
                                        self.sortTransactions()
                                        self.tableView.reloadData()
                                        self.indicator.stopAnimating()
                                        self.indicator.hidesWhenStopped = true
                                        }.validate().responseData { ( _ ) in
                                    }
                }
            }
        } catch {
            print(error)
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

        guard let transactionCell = cell as? TransactionsTableViewCell else {
            return cell
        }

        let transaction = visibleTransactions[indexPath.row]
        transactionCell.amountLabel.text = transaction.amount.formattedAsCad
        transactionCell.discountAmountLabel.text = transaction.discount.formattedAsCad
        transactionCell.dateLabel.text = TransactionsController.dateFormatter.string(from: transaction.date)
        transactionCell.locationLabel.text = transaction.location
        transactionCell.icon.image = UIImage(named: (transaction.agency.getImage()))
        transactionCell.cellSelected(content: transaction)

        return transactionCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = visibleTransactions[indexPath.row]
        transaction.expanded = !transaction.expanded
        animateRow(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1

        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            print("Loading more transactions")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false

            // Load more transactions, then stop spinner animating
            // populateStubTransactions()
            applyFilter(filterOptions)
            tableView.reloadData()
        }
    }

    private func animateRow(indexPath: IndexPath) {
        let transition = CATransition()

        transition.type = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.fillMode = kCAFillModeForwards
        transition.duration = 0.3
        transition.subtype = kCATransitionPush
        self.tableView.layer.add(transition, forKey: "refreshRowTransition")

        tableView.reloadRows(at: [indexPath], with: .none)
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
