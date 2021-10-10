//
//  AddProductViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import Firebase
import Foundation

protocol AddProductCoordinatorDelegate: AnyObject {
    func loginButtonTapped()
    func goToProductsTab()
}

protocol AddProductViewDelegate: AnyObject {
    func updateView(user: User?)
    func showErrorMessage(message: String)
    func clearView()
}

class AddProductViewModel {
    
    weak var coordinatorDelegate: AddProductCoordinatorDelegate?
    weak var viewDelegate: AddProductViewDelegate?

    let userDataManager: UserDataManager
    let addProductDataManager: AddProductDataManager
    
    var selectedCategoryId: Int?
    var coverImageData: Data?

    init(userDataManager: UserDataManager, addProductDataManager: AddProductDataManager) {
        self.userDataManager = userDataManager
        self.addProductDataManager = addProductDataManager
    }
    
    func viewWillAppear() {
        self.userDataManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            self.viewDelegate?.updateView(user: user)
        }
    }
    
    func loginButtonTapped() {
        self.coordinatorDelegate?.loginButtonTapped()
    }
    
    func selectCategory(categoryId: Int) {
        self.selectedCategoryId = categoryId
    }
    
    func selectImage(imageData: Data?) {
        self.coverImageData = imageData
    }
    
    func checkFields(title: String?, description: String?, price: String?) {
        guard let title = title, let description = description, let price = price, let priceValue = Double(price), let coverImageData = coverImageData, let selectedCategoryId = selectedCategoryId, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.viewDelegate?.showErrorMessage(message: NSLocalizedString("add_product_empty_fields_error_message", comment: ""))
            return
        }
        self.userDataManager.getCurrentUser { user in
            guard let user = user else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("add_product_empty_fields_error_message", comment: ""))
                return
            }
            self.uploadProduct(title: title, description: description, priceValue: priceValue, imageData: coverImageData, categoryId: selectedCategoryId, currentUser: user)
        }
    }
    
    func uploadProduct(title: String, description: String, priceValue: Double, imageData: Data, categoryId: Int, currentUser: User) {
        self.addProductDataManager.createNewProduct(imageData: imageData, title: title, description: description, categoryId: categoryId, price: priceValue, userUuid: currentUser.uuid, userName: currentUser.username ?? "") { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.coverImageData = nil
                self.selectedCategoryId = nil
                self.viewDelegate?.clearView()
                self.coordinatorDelegate?.goToProductsTab()
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("add_product_upload_product_error_message", comment: ""))
            }
        }
    }
}
