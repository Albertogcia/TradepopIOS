//
//  FavoritesViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 17/10/21.
//

import Foundation

protocol FavoritesCoordinatorDelegate: AnyObject {
    func loginButtonTapped()
    func toProductDetails(product: Product)
}

protocol FavoritesViewDelegate: AnyObject {
    func productsFetched()
    func showErrorMessage(message: String)
    func updateView(user: User?)
}

class FavoritesViewModel {
    weak var coordinatorDelegate: FavoritesCoordinatorDelegate?
    weak var viewDelegate: FavoritesViewDelegate?
    
    let userDataManager: UserDataManager
    let favoritesDataManager: FavoritesDataManager
    
    var productViewModels: [ProductCellViewModel] = []
    
    var previousUserUuid: String = ""
    
    init(userDataManager: UserDataManager, favoritesDataManager: FavoritesDataManager) {
        self.userDataManager = userDataManager
        self.favoritesDataManager = favoritesDataManager
    }
    
    func viewWillAppear() {
        userDataManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                if self.previousUserUuid != user.uuid {
                    self.previousUserUuid = user.uuid
                    self.productViewModels = []
                    self.viewDelegate?.updateView(user: user)
                    self.getFavoriteProducts()
                }
            }
            else {
                self.viewDelegate?.updateView(user: nil)
            }
        }
    }
    
    func getFavoriteProducts() {
        if previousUserUuid.isEmpty { return }
        favoritesDataManager.getProductsFromUserFavorites(userUuid: previousUserUuid) { error, products in
            if error == nil, let products = products {
                self.productViewModels = products.map { product in
                    ProductCellViewModel(product: product)
                }
                self.viewDelegate?.productsFetched()
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("products_error_fetching_products", comment: ""))
            }
        }
    }
    
    func loginButtonTapped(){
        coordinatorDelegate?.loginButtonTapped()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return productViewModels.count
    }
    
    func viewModel(at indexPath: IndexPath) -> ProductCellViewModel? {
        guard indexPath.row < productViewModels.count else { return nil }
        return productViewModels[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard indexPath.row < productViewModels.count else { return }
        coordinatorDelegate?.toProductDetails(product: productViewModels[indexPath.row].product)
    }
}
