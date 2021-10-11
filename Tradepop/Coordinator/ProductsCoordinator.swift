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
    
    let productsViewModel: ProductsViewModel
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, productsDataManager: ProductsDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.productsDataManager = productsDataManager
        self.productsViewModel = ProductsViewModel(userDataManager: userDataManager, productsDataManager: productsDataManager)
    }
    
    override func start() {
        let producsViewController = ProductsViewController(viewModel: productsViewModel)
        productsViewModel.coordinatorDelegate = self
        productsViewModel.viewDelegate = producsViewController
        presenter.pushViewController(producsViewController, animated: false)
    }
    
    override func finish() {
        
    }
    
    func reloadProducs(){
        productsViewModel.getAllProducts()
    }
    
}

extension ProductsCoordinator: ProductsCoordinatorDelegate{
    
}
