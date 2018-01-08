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
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!

    private enum DateConstants {
        static let MINIMUM_FILTER_YEARS_AGO: Int = 2
        static let DEFAULT_START_MONTHS_AGO: Int = 1
    }

    @IBAction func cancelDialog() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishDialog() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDatePickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FilterOptionsTableViewController {
    private func initializeDatePickers() {
        let today = Date()
        let defaultStartDate = Calendar.current.date(byAdding: .month, value: -DateConstants.DEFAULT_START_MONTHS_AGO, to: today)
        let minimumDate = Calendar.current.date(byAdding: .year, value: -DateConstants.MINIMUM_FILTER_YEARS_AGO, to: today)

        startDatePicker.minimumDate = minimumDate
        startDatePicker.maximumDate = today
        endDatePicker.minimumDate = minimumDate
        endDatePicker.maximumDate = today

        if let defaultStartDate = defaultStartDate {
            startDatePicker.date = defaultStartDate
        }
        endDatePicker.date = today
    }
}
// Workaround for correct dialog size after rotating device
extension FilterOptionsTableViewController: MZFormSheetPresentationContentSizing {
    private enum FrameConstants {
        static let FILTER_DIALOG_SCALE_X: CGFloat = 0.9
        static let FILTER_DIALOG_SCALE_Y: CGFloat = 0.8
    }

    func shouldUseContentViewFrame(for presentationController: MZFormSheetPresentationController!) -> Bool {
        return true
    }

    func contentViewFrame(for presentationController: MZFormSheetPresentationController!, currentFrame: CGRect) -> CGRect {
        var frame = currentFrame
        frame.size.width = UIScreen.main.bounds.size.width * FrameConstants.FILTER_DIALOG_SCALE_X
        frame.size.height = UIScreen.main.bounds.size.height * FrameConstants.FILTER_DIALOG_SCALE_Y
        return frame
    }
}
