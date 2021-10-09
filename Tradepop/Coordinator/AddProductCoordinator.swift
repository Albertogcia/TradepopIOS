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
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, addProductDataManager: AddProductDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.addProductDataManager = addProductDataManager
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
    
}
