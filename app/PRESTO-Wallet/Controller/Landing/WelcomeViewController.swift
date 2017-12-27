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

        if let image = logo.image {
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let renderer = UIGraphicsImageRenderer(size: image.size)

            let result = renderer.image { ctx in
                image.draw(in: rect, blendMode: .multiply, alpha: 1)
            }

            logo.image = result
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
