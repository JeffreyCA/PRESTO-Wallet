//
//  SelectTransitAgencyViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-07.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit

class SelectTransitAgencyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let list = Array(TransitAgency.cases())

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isEditing = true

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
}

extension SelectTransitAgencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SelectTransitAgencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let selectCell = cell as? SelectTransitAgencyTableViewCell {
            selectCell.name.text = list[indexPath.row].rawValue
            selectCell.icon.image = UIImage(named: list[indexPath.row].getImage())
        }

        return cell
    }
}
