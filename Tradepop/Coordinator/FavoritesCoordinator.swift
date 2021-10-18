//
//  FavoritesCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 17/10/21.
//

import UIKit

class FavoritesCoordinator: Coordinator{
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    let favoritesDataManager: FavoritesDataManager
    let productDetailsDataManager: ProductDetailsDataManager
    
    let favoritesViewModel: FavoritesViewModel
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, favoritesDataManager: FavoritesDataManager, productDetailsDataManager: ProductDetailsDataManager) {
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.favoritesDataManager = favoritesDataManager
        self.productDetailsDataManager = productDetailsDataManager
        self.favoritesViewModel = FavoritesViewModel(userDataManager: userDataManager, favoritesDataManager: favoritesDataManager)
    }
    
    override func start() {
        let favoritesViewController = FavoritesViewController(viewModel: favoritesViewModel)
        favoritesViewModel.coordinatorDelegate = self
        favoritesViewModel.viewDelegate = favoritesViewController
        presenter.pushViewController(favoritesViewController, animated: false)
    }
    
    override func finish() {
        
    }
    
    func reloadProducts() {
        favoritesViewModel.getFavoriteProducts()
    }
}

extension FavoritesCoordinator: FavoritesCoordinatorDelegate{
    func loginButtonTapped() {
        let loginRegisterCoordinator = LoginRegisterCoordinator(presenter: presenter, userDataManager: userDataManager)
        addChildCoordinator(loginRegisterCoordinator)
        loginRegisterCoordinator.start()
    }

    func toProductDetails(product: Product) {
        let productDetailsCoordinator = ProductDetailsCoordinator(presenter: presenter, selectedProduct: product, userDataManager: userDataManager, productDetailsDataManager: productDetailsDataManager) { [weak self] in
            guard let self = self else { return }
            self.reloadProducts()
        }
        addChildCoordinator(productDetailsCoordinator)
        productDetailsCoordinator.start()
    }
}
