//
//  UIViewController + Extensions.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 2/10/21.
//

import UIKit

var loadingAlert: UIAlertController?

extension UIViewController {
    func showLoadingAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message ?? NSLocalizedString("generic_loading", comment: ""), preferredStyle: .alert)
        alert.view.tintColor = .primaryColor
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = .primaryColor
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        loadingAlert = alert
        self.present(alert, animated: true)
    }

    func hideLoadingAlert(completion: (() -> Void)? = nil) {
        guard let alert = loadingAlert else { return }
        alert.dismiss(animated: true, completion: completion)
        loadingAlert = nil
    }

    func showErrorAlert(title: String? = nil, message: String? = nil, buttonMessage: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title ?? NSLocalizedString("generic_error", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMessage ?? NSLocalizedString("generic_ok", comment: ""), style: .default, handler: handler))
        self.present(alert, animated: true)
    }
    
    func showMessageAlert(title: String? = nil, message: String? = nil, buttonMessage: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMessage ?? NSLocalizedString("generic_ok", comment: ""), style: .default, handler: handler))
        self.present(alert, animated: true)
    }

    func showTextFieldAlert(title: String? = nil,
                            message: String? = nil,
                            actionTitle: String? = nil,
                            cancelTitle: String? = NSLocalizedString("generic_cancel", comment: ""),
                            inputPlaceholder: String? = nil,
                            inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                            cancelHandler: ((UIAlertAction) -> Void)? = nil,
                            actionHandler: ((_ text: String?) -> Void)? = nil)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_: UIAlertAction) in
            guard let textField = alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        self.present(alert, animated: true, completion: nil)
    }
}
