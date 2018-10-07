//
//  LandingViewController.swift
//  PRESTO Wallet
//
//  Created by Jeffrey on 2017-12-14.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, CustomPageViewDelegate {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    private var embeddedViewController: CustomPageViewController!

    func pageSwitched() {
        if let isAtEnd = embeddedViewController.isAtEnd() {
            nextButton.isHidden = isAtEnd
        }

        if let isAtBeginning = embeddedViewController.isAtBeginning() {
            backButton.isHidden = isAtBeginning
        }
    }

    @IBAction func goToNextPage(_ sender: UIButton) {
        self.embeddedViewController.goToNextPage()
        self.pageSwitched()
    }

    @IBAction func goToPreviousPage(_ sender: UIButton) {
        self.embeddedViewController.goToPreviousPage()
        self.pageSwitched()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override open var shouldAutorotate: Bool {
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CustomPageViewController,
            segue.identifier == "pageSegue" {
            vc.parentDelegate = self
            self.embeddedViewController = vc
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
