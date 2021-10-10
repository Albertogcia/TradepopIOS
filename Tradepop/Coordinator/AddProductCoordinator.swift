//
//  AddProductCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import UIKit

class AddProductCoordinator: Coordinator{
    
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    let addProductDataManager: AddProductDataManager
    let createProductCompletion: ()->()
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, addProductDataManager: AddProductDataManager, createProductCompletion: @escaping () -> ()) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.addProductDataManager = addProductDataManager
        self.createProductCompletion = createProductCompletion
    }
    
    override func start() {
        let addProductViewModel = AddProductViewModel(userDataManager: userDataManager, addProductDataManager: addProductDataManager)
        let addProductViewController = AddProductViewController(viewModel: addProductViewModel)
        addProductViewModel.coordinatorDelegate = self
        addProductViewModel.viewDelegate = addProductViewController
        presenter.pushViewController(addProductViewController, animated: false)
    }
    
    override func finish() {
        
    }
}

extension AddProductCoordinator: AddProductCoordinatorDelegate{
    func loginButtonTapped() {
        let loginRegisterCoordinator = LoginRegisterCoordinator(presenter: presenter, userDataManager: userDataManager)
        addChildCoordinator(loginRegisterCoordinator)
        loginRegisterCoordinator.start()
    }
    
    func goToProductsTab() {
        createProductCompletion()
    }
}
