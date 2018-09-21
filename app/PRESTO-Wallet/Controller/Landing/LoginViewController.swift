//
//  LoginViewController.swift
//  PRESTO Wallet
//
//  Created by Jeffrey on 2017-12-14.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIImageView!

    private enum Constants {
        static let LOGIN_BUTTON_CORNER_RADIUS: CGFloat = 5.0
        static let LOGIN_BUTTON_MASK_ALPHA: CGFloat = 0.7
        static let LOGIN_BUTTON_TAPPED_ALPHA: CGFloat = 0.7
        static let LOGIN_BUTTON_ANIMATE_DURATION: Double = 0.3
    }

    private var loginService: LoginServiceHandler?
    private var loadingView: UIAlertController?

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
        setupLoadingView()
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
    
    private func loadDashboard() {
        loginService?.loadDashboard()
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
                UIColor.white.withAlphaComponent(Constants.LOGIN_BUTTON_MASK_ALPHA)
                    .setFill()
                UIBezierPath(rect: loginButton.bounds).fill()
            }
        }

        let background = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Use image
        loginButton.image = background
        loginButton.layer.cornerRadius = Constants.LOGIN_BUTTON_CORNER_RADIUS
        loginButton.layer.masksToBounds = true
    }

    func setupLoadingView() {
        loadingView = UIAlertController(title: nil, message: "Logging in...", preferredStyle: .alert)
        loadingView?.view.tintColor = UIColor.black

        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()

        loadingView?.view.addSubview(loadingIndicator)
    }
}

// Handle tap gestures and animation
fileprivate extension LoginViewController {
    func registerTapListener(button: UIImageView) {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.minimumPressDuration = 0
        button.addGestureRecognizer(tap)
    }

    func dismissLoadingDialog(completion: @escaping () -> Void) {
        self.dismiss(animated: false, completion: completion)
    }

    func showLoadingDialog(completion: @escaping () -> Void) {
        if let loadingView = loadingView {
            self.present(loadingView, animated: true, completion: completion)
        }
    }

    func animateLoginButton(toAlpha alpha: CGFloat) {
        UIView.animate(withDuration: Constants.LOGIN_BUTTON_ANIMATE_DURATION) {
            self.loginButton.alpha = alpha
        }
    }

    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        func isTapInBounds() -> Bool {
            let point = gesture.location(in: loginButton)
            return loginButton.bounds.contains(point)
        }

        if gesture.state == .began {
            self.loginButton.alpha = Constants.LOGIN_BUTTON_TAPPED_ALPHA
        } else if gesture.state == .ended {
            if isTapInBounds() {
                showLoadingDialog {
                    self.animateLoginButton(toAlpha: 1.0)
                }

                login(username: usernameTextField.text, password: passwordTextField.text)
            } else {
                self.animateLoginButton(toAlpha: 1.0)
            }
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
        let alertDialog = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertDialog.addAction(UIAlertAction(title: "Dismiss", style: .default))

        dismissLoadingDialog {
            self.present(alertDialog, animated: true, completion: nil)
        }
    }

    func loginSuccessful() {
        dismissLoadingDialog {
            self.loadDashboard()
            self.performSegue(withIdentifier: "goToDashboard", sender: nil)
        }
    }
}
