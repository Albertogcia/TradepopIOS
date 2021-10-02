//
//  ProfileCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 20/9/21.
//

import UIKit

class ProfileCoordinator: Coordinator {
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    let loginRegisterDataManager: LoginRegisterDataManager

    init(presenter: UINavigationController, userDataManager: UserDataManager, loginRegisterDataManager: LoginRegisterDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.loginRegisterDataManager = loginRegisterDataManager
    }

    override func start() {
        let profileViewModel = ProfileViewModel(userDataManager: userDataManager)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewModel.coordinatorDelegate = self
        profileViewModel.viewDelegate = profileViewController
        presenter.pushViewController(profileViewController, animated: false)
    }

    override func finish() {}
}

// MARK: - ProfileCoordinatorDelegate

extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func loginButtonTapped() {
        let loginRegisterCoordinator = LoginRegisterCoordinator(presenter: presenter, loginRegisterDataManager: loginRegisterDataManager, userDataManager: userDataManager)
        addChildCoordinator(loginRegisterCoordinator)
        loginRegisterCoordinator.start()
    }
}
