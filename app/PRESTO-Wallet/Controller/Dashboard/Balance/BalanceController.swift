//
//  BalanceController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-10-06.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AMScrollingNavbar
import MZFormSheetPresentationController

class BalanceController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
    }

    private func setGradientBackground() {
        // TOP: #7cba0e
        let topColor = UIColor(red: 0.49, green: 0.73, blue: 0.05, alpha: 1.0)
        // BOTTOM: #2a5e13
        let bottomColor = UIColor(red: 0.27, green: 0.49, blue: 0.07, alpha: 1.0)

        let gradientColor: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0/1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations as [NSNumber]

        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
