//
//  DashboardViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-28.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit

class DashboardViewController: UITabBarController {
    let NORMAL_TAB_FONT = UIFont.boldSystemFont(ofSize: 11)
    let SELECTED_TAB_FONT = UIFont.boldSystemFont(ofSize: 11.5)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabTitleFont()
    }
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
