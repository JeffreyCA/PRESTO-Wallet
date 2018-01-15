//
//  SelectTransitAgencyTableViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-08.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import MZFormSheetPresentationController
import UIKit

protocol SelectTransitAgencyDelegate: class {
    func updateSelectedTransitAgencies(agencies: [FilterTransitAgency])
}

class SelectTransitAgencyTableViewController: UITableViewController {
    weak var delegate: SelectTransitAgencyDelegate?
    // var agencies: [FilterTransitAgency]!
    var filterOptions: FilterOptions!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.isEditing = true

        var index: Int = 0

        for agency in filterOptions.agencies {
            if agency.enabled {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            index += 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Update delegate class
        if isMovingFromParentViewController {
            delegate?.updateSelectedTransitAgencies(agencies: filterOptions.agencies)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.agencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let selectCell = cell as? SelectTransitAgencyTableViewCell {
            selectCell.name.text = filterOptions.agencies[indexPath.row].agency.rawValue
            selectCell.icon.image = UIImage(named: filterOptions.agencies[indexPath.row].agency.getImage())
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterOptions.agencies[indexPath.row].enabled = true
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        filterOptions.agencies[indexPath.row].enabled = false
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
