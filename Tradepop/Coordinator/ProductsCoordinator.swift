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
    let productDetailsDataManager: ProductDetailsDataManager
    
    let productsViewModel: ProductsViewModel
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, productsDataManager: ProductsDataManager, productDetailsDataManager: ProductDetailsDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.productsDataManager = productsDataManager
        self.productDetailsDataManager = productDetailsDataManager
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
    func toProductDetails(product: Product) {
        let productDetailsCoordinator = ProductDetailsCoordinator(presenter: presenter, selectedProduct: product, userDataManager: userDataManager, productDetailsDataManager: productDetailsDataManager) { [weak self] in
            guard let self = self else { return }
            self.reloadProducs()
        }
        addChildCoordinator(productDetailsCoordinator)
        productDetailsCoordinator.start()
    }
}
