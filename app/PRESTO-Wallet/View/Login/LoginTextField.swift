//
//  LoginTextField
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2017-12-23.
//  Copyright © 2017 JeffreyCA. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginTextField: SkyFloatingLabelTextField {
    private enum Constants {
        static let CLEAR_BUTTON_OFFSET_X: CGFloat = -6.0
        static let CLEAR_BUTTON_OFFSET_Y: CGFloat = 6.0
        static let PLACEHOLDER_OFFSET_Y: CGFloat = -7.0
        static let TITLE_OFFSET_Y: CGFloat = 10.0
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: newValue!])
        }
    }

    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .unlessEditing
        }
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return super.clearButtonRect(forBounds: bounds).offsetBy(dx: Constants.CLEAR_BUTTON_OFFSET_X, dy: Constants.CLEAR_BUTTON_OFFSET_Y)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super.placeholderRect(forBounds: bounds).offsetBy(dx: paddingLeft, dy: Constants.PLACEHOLDER_OFFSET_Y)
    }

    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        return super.titleLabelRectForBounds(bounds, editing: editing).offsetBy(dx: paddingLeft, dy: Constants.TITLE_OFFSET_Y)
    }
}
