//
//  FilterOptionsTableViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-06.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit

class FilterOptionsTableViewController: UITableViewController {
    @IBAction func cancelDialog() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishDialog() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
