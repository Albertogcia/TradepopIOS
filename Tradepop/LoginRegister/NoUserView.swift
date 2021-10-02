//
//  NoUserView.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 21/9/21.
//

import UIKit


class NoUserView: UIView {
    
    @IBOutlet var toLogInButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    var onLogInButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView(){
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        //
        toLogInButton.layer.cornerRadius = 20
        toLogInButton.clipsToBounds = true
        toLogInButton.setTitle(NSLocalizedString("no_user_to_login_button_message", comment: ""), for: .normal)
        //
        messageLabel.text = NSLocalizedString("no_user_view_label_message", comment: "")
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let onLogInButtonTapped = self.onLogInButtonTapped else { return }
        onLogInButtonTapped()
    }
    
}
