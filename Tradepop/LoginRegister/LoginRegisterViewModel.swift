//
//  LoginRegisterViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 24/9/21.
//

import Foundation

protocol LoginRegisterCoordinatorDelegate: AnyObject {
    func dismissViewController()
}

protocol LoginRegisterViewDelegate: AnyObject {
    func showErrorMessage(message: String)
    func showMessage(message: String)
    func dismissLoadingWithSuccesfull()
}

class LoginRegisterViewModel {
    weak var coordinatorDelegate: LoginRegisterCoordinatorDelegate?
    weak var viewDelegate: LoginRegisterViewDelegate?
    
    let userDataManager: UserDataManager
    let loginRegisterDataManager: LoginRegisterDataManager
    
    init(userDataManager: UserDataManager, loginRegisterDataManager: LoginRegisterDataManager) {
        self.userDataManager = userDataManager
        self.loginRegisterDataManager = loginRegisterDataManager
    }
    
    func checkLoginFields(email: String?, password: String?) {
        guard let email = email, let password = password else {
            viewDelegate?.showErrorMessage(message: NSLocalizedString("loading_register_empty_fields_error_message", comment: ""))
            return
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewDelegate?.showErrorMessage(message: NSLocalizedString("loading_register_empty_fields_error_message", comment: ""))
            return
        }
        loginUser(email: email, password: password)
    }
    
    private func loginUser(email: String, password: String) {
        userDataManager.loginUser(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.viewDelegate?.dismissLoadingWithSuccesfull()
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("loading_register_login_error_message", comment: ""))
            }
        }
    }
    
    func checkRegisterFields(userName: String?, email: String?, password: String?) {
        guard let userName = userName, let email = email, let password = password else {
            viewDelegate?.showErrorMessage(message: NSLocalizedString("loading_register_empty_fields_error_message", comment: ""))
            return
        }
        if userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewDelegate?.showErrorMessage(message: NSLocalizedString("loading_register_empty_fields_error_message", comment: ""))
            return
        }
        registerNewUser(userName: userName, email: email, password: password)
    }
    
    private func registerNewUser(userName: String, email: String, password: String) {
        userDataManager.registerNewUser(username: userName, email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.viewDelegate?.dismissLoadingWithSuccesfull()
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("loading_register_register_error_message", comment: ""))
            }
        }
    }
    
    func changePassword(email: String) {
        userDataManager.changePassword(email: email) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.viewDelegate?.showMessage(message: NSLocalizedString("login_register_recover_password_email_sent", comment: ""))
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("login_register_email_invalid", comment: ""))
            }
        }
    }
    
    func dismissViewController() {
        coordinatorDelegate?.dismissViewController()
    }
}
