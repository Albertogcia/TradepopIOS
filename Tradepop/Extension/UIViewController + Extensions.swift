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
        if let loadingAlert = loadingAlert {
            loadingAlert.dismiss(animated: true, completion: nil)
        }
        let alert = UIAlertController(title: title, message: message ?? NSLocalizedString("generic_loading", comment: ""), preferredStyle: .alert)
        alert.view.tintColor = .primaryColor
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = .primaryColor
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true)
    }
    
    func hideLoadingAlert(completion: (() -> ())? = nil){
        guard let alert = loadingAlert else { return }
        alert.dismiss(animated: true, completion: completion)
    }
    
    func showErrorAlert(title: String? = nil, message: String? = nil, buttonMessage: String? = nil, handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title ?? NSLocalizedString("generic_error", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonMessage ?? NSLocalizedString("generic_ok", comment: ""), style: .default, handler: handler))
    }
}
