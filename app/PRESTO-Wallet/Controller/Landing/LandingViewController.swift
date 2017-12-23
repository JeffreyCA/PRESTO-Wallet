//
//  LandingViewController.swift
//  PRESTO Wallet
//
//  Created by Jeffrey on 2017-12-14.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, CustomPageViewDelegate {
    @IBOutlet weak var nextButton: UIButton!
    private var embeddedViewController: CustomPageViewController!

    func pageSwitched(customPageViewController: CustomPageViewController) {
        print ("switched")
        if let isAtEnd = customPageViewController.isAtEnd() {
            nextButton.isHidden = isAtEnd
        }
    }
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        self.embeddedViewController.goToNextPage()
        self.pageSwitched(customPageViewController: embeddedViewController)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
