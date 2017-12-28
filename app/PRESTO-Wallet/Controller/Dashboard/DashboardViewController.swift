//
//  DashboardViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-28.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

class DashboardViewController: UITabBarController {
    let NORMAL_TAB_FONT = UIFont.boldSystemFont(ofSize: 10.5)
    let SELECTED_TAB_FONT = UIFont.boldSystemFont(ofSize: 11)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabTitleFont()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected tab")
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

extension DashboardViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTabTitleFont()
    }

    private func updateTabTitleFont() {
        // Bold tab title when selected
        viewControllers?.forEach { (viewController: UIViewController) in
            viewController.tabBarItem.setTitleTextAttributes([.font: viewController == self.selectedViewController
                ? SELECTED_TAB_FONT : NORMAL_TAB_FONT], for: .normal)
        }
    }
}
