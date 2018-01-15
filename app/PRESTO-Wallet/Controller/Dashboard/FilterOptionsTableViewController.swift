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
    @IBOutlet weak var selectedAgenciesLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!

    // Used to expand/collapse date pickers
    private var isStartDatePickerVisible = false
    private var isEndDatePickerVisible = false

    private var filterOptions: FilterOptions?

    private enum Constants {
        static let MINIMUM_FILTER_YEARS_AGO: Int = 2
        static let DEFAULT_START_MONTHS_AGO: Int = 1
        static let SELECTED_AGENCIES_HINT: String = " Selected"
        static let DATE_TODAY_HINT: String = " (Today)"
    }

    @IBAction func resetDialog() {
        print("Reset filter options")
    }

    @IBAction func finishDialog() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction
    public func didChangeDate() {
        updateDateText()
        updateFilterOptionsDates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDatePickers()

        filterOptions = FilterOptions(startDate: startDatePicker.date, endDate: endDatePicker.date, agencies: createTransitAgencyArray())

        updateDateText()
        updateSelectedAgenciesText()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare")
        let destination = segue.destination as? SelectTransitAgencyTableViewController
        destination?.delegate = self
        destination?.filterOptions = filterOptions
    }
}

// Configure date picker and date labels
extension FilterOptionsTableViewController {
    // Create array of all transit agencies set to enabled
    private func createTransitAgencyArray() -> [FilterTransitAgency] {
        var array = [FilterTransitAgency]()
        TransitAgency.cases().forEach({
            array.append(FilterTransitAgency(agency: $0, enabled: true))
        })
        
        return array
    }

    private func initializeDatePickers() {
        let today = Date()
        let defaultStartDate = Calendar.current.date(byAdding: .month, value: -Constants.DEFAULT_START_MONTHS_AGO, to: today)
        let minimumDate = Calendar.current.date(byAdding: .year, value: -Constants.MINIMUM_FILTER_YEARS_AGO, to: today)

        startDatePicker.minimumDate = minimumDate
        endDatePicker.minimumDate = minimumDate
        startDatePicker.maximumDate = today
        endDatePicker.maximumDate = today

        if let defaultStartDate = defaultStartDate {
            startDatePicker.date = defaultStartDate
        }

        endDatePicker.date = today
    }

    private func toggleStartDatePicker() {
        isStartDatePickerVisible = !isStartDatePickerVisible
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    private func toggleEndDatePicker() {
        isEndDatePickerVisible = !isEndDatePickerVisible
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    private func updateDateText() {
        startDateLabel.text = DateFormatter.localizedString(from: startDatePicker.date, dateStyle: .long, timeStyle: .none)
        endDateLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: .long, timeStyle: .none)

        // Append "(Today)" hint to end of date text if date is today
        if Calendar.current.isDateInToday(startDatePicker.date) {
            startDateLabel.text?.append(Constants.DATE_TODAY_HINT)
        }

        if Calendar.current.isDateInToday(endDatePicker.date) {
            endDateLabel.text?.append(Constants.DATE_TODAY_HINT)
        }
    }

    // Count number of agencies that are enabled
    private func getSelectedAgenciesCount() -> Int {
        var count: Int = 0
        self.filterOptions?.agencies.forEach({ (agency) in
            if agency.enabled {
                count += 1
            }
        })
        return count
    }
    
    private func updateSelectedAgenciesText() {
        selectedAgenciesLabel.text = String(getSelectedAgenciesCount()) + Constants.SELECTED_AGENCIES_HINT
    }

    private func updateFilterOptionsDates() {
        self.filterOptions?.startDate = startDatePicker.date
        self.filterOptions?.endDate = endDatePicker.date
    }
}

// UITableViewController functions
extension FilterOptionsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle corresponding date picker
        if indexPath.row == 1 {
            // Only one date picker should be visible at any time
            // Collapse other cell if visible
            if isEndDatePickerVisible {
                toggleEndDatePicker()
            }
            toggleStartDatePicker()
        } else if indexPath.row == 3 {
            // Only one date picker should be visible at any time
            // Collapse other cell if visible
            if isStartDatePickerVisible {
                toggleStartDatePicker()
            }
            toggleEndDatePicker()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // TODO: Use Enums for cell indices
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isStartDatePickerVisible && indexPath.row == 2 {
            return 0
        } else if !isEndDatePickerVisible && indexPath.row == 4 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

extension FilterOptionsTableViewController: SelectTransitAgencyDelegate {
    func updateSelectedTransitAgencies(agencies: [FilterTransitAgency]) {
        print("Update")
        self.filterOptions?.agencies = agencies
        updateSelectedAgenciesText()
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
