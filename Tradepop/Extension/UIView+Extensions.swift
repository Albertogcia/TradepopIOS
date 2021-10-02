//
//  UIView+Extensions.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 1/10/21.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
