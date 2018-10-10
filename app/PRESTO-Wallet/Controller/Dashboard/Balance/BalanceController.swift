//
//  BalanceController.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-10-06.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

class BalanceController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var fareTypeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!

    private var loadingView: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        setGradientBackground()
        setupLoadingView()
        populateBalanceInfo()
    }

    func populateBalanceInfo() {
        showLoadingDialog()

        Alamofire.request(APIConstant.BASE_URL + APIConstant.DASHBOARD_PATH, method: .get, encoding: JSONEncoding.default, headers: nil).responseString { response in
            if let html = response.result.value {
                do {
                    let doc: Document = try SwiftSoup.parse(html)

                    let balanceElement = try doc.getElementsByClass("dashboard__quantity").first()
                    let cardNumElement = try doc.getElementById("cardNumber")
                    let hiddenElements = try doc.getElementsByClass("dashboard__hidden")
                    let fareTypeElement = try hiddenElements.get(1).getElementsByTag("span").get(0)

                    if let balance = try balanceElement?.text() {
                        self.balanceLabel.text = balance
                        print("Balance: " + balance)
                    }

                    if let cardNum = try cardNumElement?.text() {
                        self.cardNumberLabel.text = cardNum
                        print("Card Number: " + cardNum)
                    }

                    self.fareTypeLabel.text = try fareTypeElement.text()

                    // Set last updated text to current time
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                    let date = Date()
                    let dateString = dateFormatter.string(from: date)
                    self.lastUpdatedLabel.text = dateString

                    self.dismissLoadingDialog()
                } catch Exception.Error(let type, let message) {
                    print(type)
                    print(message)
                } catch {
                    print("Error")
                }
            }
        }
    }
}

fileprivate extension BalanceController {
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

    func dismissLoadingDialog() {
        self.dismiss(animated: false, completion: nil)
    }

    func showLoadingDialog() {
        self.present(loadingView!, animated: true, completion: nil)
    }

    func setupLoadingView() {
        loadingView = UIAlertController(title: nil, message: "Loading data...", preferredStyle: .alert)
        loadingView?.view.tintColor = UIColor.black

        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()

        loadingView?.view.addSubview(loadingIndicator)
    }
}
