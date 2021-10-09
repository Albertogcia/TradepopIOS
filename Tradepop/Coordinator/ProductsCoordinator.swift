//
//  ProductsCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import UIKit

class ProductsCoordinator: Coordinator{
    
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    let productsDataManager: ProductsDataManager
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, productsDataManager: ProductsDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.productsDataManager = productsDataManager
    }
    
    override func start() {
        let productsViewModel = ProductsViewModel(userDataManager: userDataManager, productsDataManager: productsDataManager)
        let producsViewController = ProductsViewController(viewModel: productsViewModel)
        productsViewModel.coordinatorDelegate = self
        productsViewModel.viewDelegate = producsViewController
        presenter.pushViewController(producsViewController, animated: false)
    }
    
    override func finish() {
        
    }
    
}

extension ProductsCoordinator: ProductsCoordinatorDelegate{
    
}
