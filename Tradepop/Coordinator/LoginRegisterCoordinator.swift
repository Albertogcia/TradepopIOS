//
//  LoginRegisterCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 1/10/21.
//

import UIKit

class LoginRegisterCoordinator: Coordinator{
    let presenter: UINavigationController
    let loginRegisterDataManager: LoginRegisterDataManager
    let userDataManager: UserDataManager
    
    init(presenter: UINavigationController, loginRegisterDataManager: LoginRegisterDataManager, userDataManager: UserDataManager) {
        self.presenter = presenter
        self.loginRegisterDataManager = loginRegisterDataManager
        self.userDataManager = userDataManager
    }
    
    override func start() {
        let loginRegisterViewModel = LoginRegisterViewModel(userDataManager: userDataManager, loginRegisterDataManager: loginRegisterDataManager)
        let loginRegisterViewController = LoginRegisterViewController(viewModel: loginRegisterViewModel)
        loginRegisterViewModel.coordinatorDelegate = self
        loginRegisterViewModel.viewDelegate = loginRegisterViewController
        presenter.pushViewController(loginRegisterViewController, animated: true)
        //presenter.showDetailViewController(loginRegisterViewController, sender: nil)
    }
    
    override func finish() {
    }
}

extension LoginRegisterCoordinator: LoginRegisterCoordinatorDelegate{
    
}
