//
//  SelectTransitAgencyTableViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-08.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import MZFormSheetPresentationController
import UIKit

class SelectTransitAgencyTableViewController: UITableViewController {
    let list = Array(TransitAgency.cases())

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            print("not null")
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.isEditing = true

        let length: Int = tableView.numberOfRows(inSection: 0)

        // TODO Save/load selected rows
        for row in 0 ... length {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let selectCell = cell as? SelectTransitAgencyTableViewCell {
            selectCell.name.text = list[indexPath.row].rawValue
            selectCell.icon.image = UIImage(named: list[indexPath.row].getImage())
        }

        return cell
    }
}

// Workaround for correct dialog size after rotating device
extension SelectTransitAgencyTableViewController: MZFormSheetPresentationContentSizing {
    private enum Constants {
        static let FILTER_DIALOG_SCALE_X: CGFloat = 0.9
        static let FILTER_DIALOG_SCALE_Y: CGFloat = 0.8
    }

    func shouldUseContentViewFrame(for presentationController: MZFormSheetPresentationController!) -> Bool {
        return true
    }

    func contentViewFrame(for presentationController: MZFormSheetPresentationController!, currentFrame: CGRect) -> CGRect {
        var frame = currentFrame
        frame.size.width = UIScreen.main.bounds.size.width * Constants.FILTER_DIALOG_SCALE_X
        frame.size.height = UIScreen.main.bounds.size.height * Constants.FILTER_DIALOG_SCALE_Y
        return frame
    }
}
