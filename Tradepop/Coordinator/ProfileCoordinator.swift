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
    let profileDataManager: ProfileDataManager
    
    let profileViewModel: ProfileViewModel

    init(presenter: UINavigationController, userDataManager: UserDataManager, profileDataManager: ProfileDataManager) {
        self.presenter = presenter
        self.profileDataManager = profileDataManager
        self.userDataManager = userDataManager
        self.profileViewModel = ProfileViewModel(userDataManager: userDataManager, profileDataManager: profileDataManager)
    }

    override func start() {
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewModel.coordinatorDelegate = self
        profileViewModel.viewDelegate = profileViewController
        presenter.pushViewController(profileViewController, animated: false)
    }

    override func finish() {}
    
    func reloadProducts(){
        profileViewModel.getUserProducts()
    }
}

// MARK: - ProfileCoordinatorDelegate

extension ProfileCoordinator: ProfileCoordinatorDelegate {
    func loginButtonTapped() {
        let loginRegisterCoordinator = LoginRegisterCoordinator(presenter: presenter, userDataManager: userDataManager)
        addChildCoordinator(loginRegisterCoordinator)
        loginRegisterCoordinator.start()
    }
}
