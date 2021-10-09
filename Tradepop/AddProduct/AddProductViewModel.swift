//
//  AddProductViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import Foundation

protocol AddProductCoordinatorDelegate: AnyObject {}

protocol AddProductViewDelegate: AnyObject {}

class AddProductViewModel {
    
    weak var coordinatorDelegate: AddProductCoordinatorDelegate?
    weak var viewDelegate: AddProductViewDelegate?

    let userDataManager: UserDataManager
    let addProductDataManager: AddProductDataManager

    init(userDataManager: UserDataManager, addProductDataManager: AddProductDataManager) {
        self.userDataManager = userDataManager
        self.addProductDataManager = addProductDataManager
    }
}
