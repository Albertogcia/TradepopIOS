//
//  ProductsViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import Foundation

protocol ProductsCoordinatorDelegate: AnyObject {
    func toProductDetails(product: Product)
}

protocol ProductsViewDelegate: AnyObject {
    func productsFetched()
    func showErrorMessage(message: String)
}

class ProductsViewModel {
    
    weak var coordinatorDelegate: ProductsCoordinatorDelegate?
    weak var viewDelegate: ProductsViewDelegate?
    
    let userDataManager: UserDataManager
    let productsDataManager: ProductsDataManager
    
    var productViewModels: [ProductCellViewModel] = []
    var filteredProductViewModels: [ProductCellViewModel] = []
    
    var textToFilter: String = ""
    var previousUserUuid: String? = nil
    
    init(userDataManager: UserDataManager, productsDataManager: ProductsDataManager) {
        self.userDataManager = userDataManager
        self.productsDataManager = productsDataManager
    }
    
    func viewWillAppear(){
        userDataManager.getCurrentUser { user in
            if let user = user{
                if let previousUserUuid = self.previousUserUuid{
                    if previousUserUuid != user.uuid{
                        self.previousUserUuid = user.uuid
                        self.getAllProducts()
                    }
                }
                else{
                    self.previousUserUuid = user.uuid
                    self.getAllProducts()
                }
            }
            else{
                self.previousUserUuid = nil
                self.getAllProducts()
            }
        }
    }
    
    func getAllProducts() {
        productsDataManager.getAllProducts(userUuid: previousUserUuid) { [weak self] error, products in
            guard let self = self else { return }
            if error == nil, let products = products {
                self.productViewModels = products.map { product in
                    ProductCellViewModel(product: product)
                }
                self.filterProducts()
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("products_error_fetching_products", comment: ""))
            }
        }
    }
    
    func setTextToFilter(textToFilter: String) {
        self.textToFilter = textToFilter.lowercased()
        filterProducts()
    }
    
    func filterProducts() {
        if !textToFilter.isEmpty {
            filteredProductViewModels = productViewModels.filter {
                $0.product.title?.lowercased().contains(textToFilter) ?? false || $0.product.description?.lowercased().contains(textToFilter) ?? false
            }
        }
        else {
            filteredProductViewModels = productViewModels
        }
        viewDelegate?.productsFetched()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return filteredProductViewModels.count
    }
    
    func viewModel(at indexPath: IndexPath) -> ProductCellViewModel? {
        guard indexPath.row < filteredProductViewModels.count else { return nil }
        return filteredProductViewModels[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard indexPath.row < filteredProductViewModels.count else { return }
        coordinatorDelegate?.toProductDetails(product: filteredProductViewModels[indexPath.row].product)
    }
}
