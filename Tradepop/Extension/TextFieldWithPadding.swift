//
//  TextFieldWithPadding.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 10/10/21.
//

import UIKit

@IBDesignable
class TextFieldWithPadding: UITextField {

@IBInspectable var horizontalInset: CGFloat = 0
@IBInspectable var verticalInset: CGFloat = 0

override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
}

override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: horizontalInset , dy: verticalInset)
}

override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: horizontalInset, dy: verticalInset)
}
}
