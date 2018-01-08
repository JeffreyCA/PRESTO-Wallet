//
//  FilterOptionsTableViewController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-06.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import MZFormSheetPresentationController
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

extension FilterOptionsTableViewController: MZFormSheetPresentationContentSizing {
    private enum Constants {
        static let FILTER_DIALOG_SCALE_X: CGFloat = 0.9
        static let FILTER_DIALOG_SCALE_Y: CGFloat = 0.8
    }

    func shouldUseContentViewFrame(for presentationController: MZFormSheetPresentationController!) -> Bool {
        return true
    }

    func contentViewFrame(for presentationController: MZFormSheetPresentationController!, currentFrame: CGRect) -> CGRect {
        var frame = currentFrame
        frame.size.width = UIScreen.main.bounds.size.width * Constants.FILTER_DIALOG_SCALE_X
        frame.size.height = UIScreen.main.bounds.size.height * Constants.FILTER_DIALOG_SCALE_Y
        return frame
    }
}
