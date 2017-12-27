//
//  LoginViewController.swift
//  PRESTO Wallet
//
//  Created by Jeffrey on 2017-12-14.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIImageView!

    private static let LOGIN_BUTTON_CORNER_RADIUS: CGFloat = 5.0
    private static let LOGIN_BUTTON_MASK_ALPHA: CGFloat = 0.7
    private static let LOGIN_BUTTON_TAPPED_ALPHA: CGFloat = 0.7
    private static let LOGIN_BUTTON_ANIMATE_DURATION: Double = 0.3

    private var loginService: LoginServiceHandler?
    private var indicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loginService = LoginServiceHandler(delegate: self)

        registerTapListener(button: loginButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMaskForView(text: "Add Account")
        insertLoadingIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func login(username: String?, password: String?) {
        loginService?.login(withUsername: username, password: password)
    }
}

// Update views
fileprivate extension LoginViewController {
    func updateMaskForView(text: String) {
        UIGraphicsBeginImageContextWithOptions(loginButton.bounds.size, true, 0)
        let context = UIGraphicsGetCurrentContext()

        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -loginButton.bounds.size.height)

        // Draw the text
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]

        let size = text.size(withAttributes: attributes)
        let point = CGPoint(x: (loginButton.bounds.size.width - size.width) / 2.0, y: (loginButton.bounds.size.height
            - size.height) / 2.0)
        text.draw(at: point, withAttributes: attributes)

        // Capture the image and end context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Create image mask
        if let cgImage = image?.cgImage {
            let bytesPerRow = cgImage.bytesPerRow
            let dataProvider = cgImage.dataProvider
            let bitsPerPixel = cgImage.bitsPerPixel
            let width = cgImage.width
            let height = cgImage.height
            let bitsPerComponent = cgImage.bitsPerComponent

            let mask = CGImage(maskWidth: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, provider: dataProvider!, decode: nil, shouldInterpolate: false)

            // Create background
            if let mask = mask {
                UIGraphicsBeginImageContextWithOptions(loginButton.bounds.size, false, 0)
                UIGraphicsGetCurrentContext()?.clip(to: loginButton.bounds, mask: mask)
                UIColor.white.withAlphaComponent(LoginViewController.LOGIN_BUTTON_MASK_ALPHA)
                    .setFill()
                UIBezierPath(rect: loginButton.bounds).fill()
            }
        }

        let background = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Use image
        loginButton.image = background
        loginButton.layer.cornerRadius = LoginViewController.LOGIN_BUTTON_CORNER_RADIUS
        loginButton.layer.masksToBounds = true
    }

    func insertLoadingIndicator() {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator?.center = CGPoint(x: loginButton.frame.width  / 2, y: loginButton.frame.height / 2)
        loginButton.addSubview(indicator!)
        loginButton.bringSubview(toFront: indicator!)
    }
}

// Handle tap gestures and animation
fileprivate extension LoginViewController {
    func registerTapListener(button: UIImageView) {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.minimumPressDuration = 0
        button.addGestureRecognizer(tap)
    }

    func startAnimating() {
        self.loginButton.alpha = LoginViewController.LOGIN_BUTTON_TAPPED_ALPHA
        loginButton.isUserInteractionEnabled = false
        indicator?.startAnimating()
    }

    func stopAnimating() {
        UIView.animate(withDuration: LoginViewController.LOGIN_BUTTON_ANIMATE_DURATION) {
            self.loginButton.alpha = 1.0
        }

        loginButton.isUserInteractionEnabled = true
        indicator?.stopAnimating()
    }

    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.loginButton.alpha = LoginViewController.LOGIN_BUTTON_TAPPED_ALPHA
        } else if gesture.state == .ended {
            startAnimating()
            login(username: usernameTextField.text, password: passwordTextField.text)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController: LoginServiceDelegate {
    func handle(error: String) {
        stopAnimating()
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true)
    }

    func loginSuccessful() {
        stopAnimating()
        let alert = UIAlertController(title: "Success", message: "Logged in.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Proceed", style: .default))
        self.present(alert, animated: true)
    }
}
