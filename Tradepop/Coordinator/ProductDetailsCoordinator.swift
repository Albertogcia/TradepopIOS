//
//  ProductDetailsCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 11/10/21.
//

import UIKit

class ProductDetailsCoordinator: Coordinator {
    
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    let productDetailsDataManager: ProductDetailsDataManager
    let selectedProduct: Product
    let changesCompletion: () -> ()
    
    init(presenter: UINavigationController, selectedProduct: Product, userDataManager: UserDataManager, productDetailsDataManager: ProductDetailsDataManager, changesCompletion: @escaping () -> ()) {
        self.presenter = presenter
        self.selectedProduct = selectedProduct
        self.userDataManager = userDataManager
        self.productDetailsDataManager = productDetailsDataManager
        self.changesCompletion = changesCompletion
    }
    
    override func start() {
        let productDetailsViewModel = ProductDetailsViewModel(userDataManager: userDataManager, productDetailsDataManager: productDetailsDataManager, product: selectedProduct)
        let productDetailsViewController = ProductDetailsViewController(viewModel: productDetailsViewModel)
        productDetailsViewModel.coordinatorDelegate = self
        productDetailsViewModel.viewDelegate = productDetailsViewController
        presenter.pushViewController(productDetailsViewController, animated: true)
    }
    
    override func finish() {
        presenter.popViewController(animated: true)
        changesCompletion()
    }
}

extension ProductDetailsCoordinator: ProductDetailsCoordinatorDelegate{
    func dismiss() {
        finish()
    }
}
