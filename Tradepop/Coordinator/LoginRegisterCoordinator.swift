//
//  LoginRegisterCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 1/10/21.
//

import UIKit

class LoginRegisterCoordinator: Coordinator{
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    
    init(presenter: UINavigationController, userDataManager: UserDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
    }
    
    override func start() {
        let loginRegisterViewModel = LoginRegisterViewModel(userDataManager: userDataManager)
        let loginRegisterViewController = LoginRegisterViewController(viewModel: loginRegisterViewModel)
        loginRegisterViewModel.coordinatorDelegate = self
        loginRegisterViewModel.viewDelegate = loginRegisterViewController
        presenter.pushViewController(loginRegisterViewController, animated: true)
    }
    
    override func finish() {
        presenter.popViewController(animated: true)
    }
}

extension LoginRegisterCoordinator: LoginRegisterCoordinatorDelegate{
    func dismissViewController() {
        finish()
    }
}
