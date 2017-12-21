//
//  LandingViewController.swift
//  PRESTO Wallet
//
//  Created by Jeffrey on 2017-12-14.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var containerView: CustomPageViewController!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        self.embeddedViewController.goToNextPage()
    }
    
    private var embeddedViewController: CustomPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CustomPageViewController,
            segue.identifier == "pageSegue" {
            self.embeddedViewController = vc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
