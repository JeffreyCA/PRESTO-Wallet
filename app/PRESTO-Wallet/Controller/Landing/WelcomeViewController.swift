//
//  WelcomeViewController.swift
//  PRESTO Wallet
//
//  Created by Jeffrey on 2017-12-14.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply blend mode to PRESTO logo
        if let image = logo.image {
            // UIGraphicsImageRenderer only supports iOS 10+, otherwise use UIGraphicsBeginImageContext
            if #available(iOS 10.0, *) {
                let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                let renderer = UIGraphicsImageRenderer(size: image.size)

                let result = renderer.image { _ in
                    image.draw(in: rect, blendMode: .multiply, alpha: 1)
                }
                logo.image = result
            } else {
                // Draw rect is different than when using UIGraphicsImageRenderer
                let rect = CGRect(x: 0, y: 0, width: logo.bounds.width, height: logo.bounds.height)
                UIGraphicsBeginImageContextWithOptions(logo.bounds.size, false, 0)
                image.draw(in: rect, blendMode: .multiply, alpha: 1)
                logo.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
