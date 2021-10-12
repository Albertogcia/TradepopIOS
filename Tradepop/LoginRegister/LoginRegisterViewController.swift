//
//  LoginRegisterViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 24/9/21.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet var loginSelectorLabel: UILabel!
    @IBOutlet var loginSelectorUnderline: UIView!
    @IBOutlet var registerSelectorLabel: UILabel!
    @IBOutlet var registerSelectorUnderline: UIView!
    
    @IBOutlet var loginView: UIView!
    @IBOutlet var loginViewTitleLabel: UILabel!
    @IBOutlet var loginEmailTextField: UITextField!
    @IBOutlet var loginPasswordTextField: UITextField!
    @IBOutlet var loginForgotPasswordLabel: UILabel!
    @IBOutlet var loginLoginButton: UIButton!
    @IBOutlet var loginSeePasswordButton: UIButton!
    
    @IBOutlet var registerView: UIView!
    @IBOutlet var registerTitleLabel: UILabel!
    @IBOutlet var registerNameTextField: UITextField!
    @IBOutlet var registerEmailTextField: UITextField!
    @IBOutlet var registerPasswordTextField: UITextField!
    @IBOutlet var registerRegisterButton: UIButton!
    @IBOutlet var registerSeePasswordButton: UIButton!
    
    // MARK: - Attributes
    let viewModel: LoginRegisterViewModel
    
    // MARK: - Initializers
    init(viewModel: LoginRegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Functions
    private func configureView() {
        loginSelectorLabel.text = NSLocalizedString("login_register_login_title", comment: "")
        registerSelectorLabel.text = NSLocalizedString("login_register_register_title", comment: "")
        
        loginViewTitleLabel.text = NSLocalizedString("login_register_login_title", comment: "")
        loginEmailTextField.placeholder = NSLocalizedString("login_register_email_label", comment: "")
        loginPasswordTextField.placeholder = NSLocalizedString("login_register_password_label", comment: "")
        loginForgotPasswordLabel.text = NSLocalizedString("login_register_forgot_password", comment: "")
        loginLoginButton.setTitle(NSLocalizedString("login_register_login_title", comment: ""), for: .normal)
        
        registerTitleLabel.text = NSLocalizedString("login_register_register_title", comment: "")
        registerNameTextField.placeholder = NSLocalizedString("login_register_username_label", comment: "")
        registerEmailTextField.placeholder = NSLocalizedString("login_register_email_label", comment: "")
        registerPasswordTextField.placeholder = NSLocalizedString("login_register_password_label", comment: "")
        registerRegisterButton.setTitle(NSLocalizedString("login_register_register_title", comment: ""), for: .normal)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        mainScrollView.contentInset = UIEdgeInsets.zero
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        showLoadingAlert(message: NSLocalizedString("loading_register_login_message", comment: ""))
        viewModel.checkLoginFields(email: loginEmailTextField.text, password: loginPasswordTextField.text)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        showLoadingAlert()
        viewModel.checkRegisterFields(userName: registerNameTextField.text, email: registerEmailTextField.text, password: registerPasswordTextField.text)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerViewShowPasswordTapped(_ sender: UIButton) {
        registerPasswordTextField.isSecureTextEntry = !registerPasswordTextField.isSecureTextEntry
        registerSeePasswordButton.setImage(registerPasswordTextField.isSecureTextEntry ? UIImage(named: "icon_close_eye") : UIImage(named: "icon_open_eye"), for: .normal)
    }
    
    @IBAction func loginViewShowPasswordTapped(_ sender: UIButton) {
        loginPasswordTextField.isSecureTextEntry = !loginPasswordTextField.isSecureTextEntry
        loginSeePasswordButton.setImage(loginPasswordTextField.isSecureTextEntry ? UIImage(named: "icon_close_eye") : UIImage(named: "icon_open_eye"), for: .normal)
    }
    
    @IBAction func loginSelectorTapped(_ sender: UITapGestureRecognizer) {
        registerSelectorLabel.alpha = 0.4
        registerSelectorUnderline.isHidden = true
        registerView.isHidden = true
        //
        loginSelectorLabel.alpha = 1.0
        loginSelectorUnderline.isHidden = false
        loginView.isHidden = false
    }
    
    @IBAction func registerSelectorTapped(_ sender: UITapGestureRecognizer) {
        loginSelectorLabel.alpha = 0.4
        loginSelectorUnderline.isHidden = true
        loginView.isHidden = true
        //
        registerSelectorLabel.alpha = 1
        registerSelectorUnderline.isHidden = false
        registerView.isHidden = false
    }
    
    @IBAction func forggotPasswordTapped(_ sender: UITapGestureRecognizer) {
        showTextFieldAlert(message: NSLocalizedString("login_register_forgot_password_message", comment: ""),
                           actionTitle: NSLocalizedString("genering_send", comment: ""),
                           inputPlaceholder: NSLocalizedString("login_register_email_label", comment: ""),
                           actionHandler: { [weak self] email in
                               guard let self = self, let email = email else { return }
                               self.showLoadingAlert()
                               self.viewModel.changePassword(email: email)
                           })
    }
}

extension LoginRegisterViewController: LoginRegisterViewDelegate {
    func dismissLoadingWithSuccesfull() {
        hideLoadingAlert { [weak self] in
            guard let self = self else { return }
            self.viewModel.dismissViewController()
        }
    }
    
    func showErrorMessage(message: String) {
        hideLoadingAlert { [weak self] in
            guard let self = self else { return }
            self.showErrorAlert(message: message)
        }
    }
    
    func showMessage(message: String) {
        hideLoadingAlert { [weak self] in
            guard let self = self else { return }
            self.showMessageAlert(message: message)
        }
    }
}
