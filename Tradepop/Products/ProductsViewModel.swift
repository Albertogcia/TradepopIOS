//
//  ProductsViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import Foundation

protocol ProductsCoordinatorDelegate: AnyObject{
    
}

protocol ProductsViewDelegate: AnyObject{
    
}

class ProductsViewModel{
    
    weak var coordinatorDelegate: ProductsCoordinatorDelegate?
    weak var viewDelegate: ProductsViewDelegate?
    
    let userDataManager: UserDataManager
    let productsDataManager: ProductsDataManager
    
    init(userDataManager: UserDataManager, productsDataManager: ProductsDataManager) {
        self.userDataManager = userDataManager
        self.productsDataManager = productsDataManager
    }
}
