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
    
    private static let LOGIN_BUTTON_TAPPED_ALPHA: CGFloat = 0.7
    private static let LOGIN_BUTTON_ANIMATE_DURATION: Double = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        updateMaskForView(button: loginButton, text: "Add Account")
        registerTapListener(button: loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func login(username: String?, password: String?) {
        Session.login(username: username!, password: password!)
    }
    
    func updateMaskForView(button: UIImageView, text: String) {
        UIGraphicsBeginImageContextWithOptions(button.bounds.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -button.bounds.size.height)
        
        // Draw the text
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.white,
        ]
        
        let size = text.size(withAttributes: attributes)
        let point = CGPoint(x: (button.bounds.size.width - size.width) / 2.0, y: (button.bounds.size.height - size.height) / 2.0)
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
                UIGraphicsBeginImageContextWithOptions(button.bounds.size, false, 0)
                UIGraphicsGetCurrentContext()?.clip(to: button.bounds, mask: mask)
                UIColor.white.withAlphaComponent(0.8).setFill()
                UIBezierPath(rect: button.bounds).fill()
            }
        }
        
        let background = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Use image
        button.image = background
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
    }
    
    func registerTapListener(button: UIImageView) {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.minimumPressDuration = 0
        button.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            self.loginButton.alpha = LoginViewController.LOGIN_BUTTON_TAPPED_ALPHA
        } else if gesture.state == .ended {
            UIView.animate(withDuration: LoginViewController.LOGIN_BUTTON_ANIMATE_DURATION) {
                self.loginButton.alpha = 1.0
            }
            
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
            login(username: usernameTextField.text, password: passwordTextField.text)
        }
        return true
    }
}
