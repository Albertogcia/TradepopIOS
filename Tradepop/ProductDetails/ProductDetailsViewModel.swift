//
//  ProductDetailsViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 11/10/21.
//

import Foundation

protocol ProductDetailsViewDelegate: AnyObject {
    func updateView()
    func showErrorMessage(message: String)
    func dismissLoadingAlert()
}

protocol ProductDetailsCoordinatorDelegate: AnyObject {
    func dismiss()
}

class ProductDetailsViewModel {
    
    weak var coordinatorDelegate: ProductDetailsCoordinatorDelegate?
    weak var viewDelegate: ProductDetailsViewDelegate?
    
    let userDataManager: UserDataManager
    let productDetailsDataManager: ProductDetailsDataManager
    
    let product: Product
    
    var user: User?
    var selectedCategoryId: Int?
    var coverImageData: Data?
    
    var productTitleText: String?
    var productDescriptionText: String?
    var productCategoryString: String?
    var productPriceText: String?
    var imageUrl: String?
    
    var showBuyButton: Bool = false
    var showEditButtons: Bool = false
    
    init(userDataManager: UserDataManager, productDetailsDataManager: ProductDetailsDataManager, product: Product) {
        self.userDataManager = userDataManager
        self.productDetailsDataManager = productDetailsDataManager
        self.product = product
        
        configureTexts()
    }
    
    private func configureTexts() {
        productTitleText = product.title
        productDescriptionText = product.description
        imageUrl = product.coverImageUrl
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        productPriceText = formatter.string(from: NSNumber(value: product.price ?? 0.0))
        let categoryId = product.categoryId ?? 1
        selectedCategoryId = categoryId
        switch categoryId {
        case 1:
            productCategoryString = NSLocalizedString("category_1", comment: "")
        case 2:
            productCategoryString = NSLocalizedString("category_2", comment: "")
        case 3:
            productCategoryString = NSLocalizedString("category_3", comment: "")
        case 4:
            productCategoryString = NSLocalizedString("category_4", comment: "")
        case 5:
            productCategoryString = NSLocalizedString("category_5", comment: "")
        default:
            break
        }
    }
    
    func viewDidLoad() {
        userDataManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            self.user = user
            if let user = user {
                if user.uuid == self.product.ownerUuid ?? "" {
                    self.showEditButtons = true
                }
                else {
                    self.showBuyButton = true
                }
            }
            self.viewDelegate?.updateView()
        }
    }
    
    func selectCategory(categoryId: Int) {
        selectedCategoryId = categoryId
    }
    
    func selectImage(imageData: Data?) {
        coverImageData = imageData
    }
    
    func buyButtonTapped() {
        guard let user = user else {
            coordinatorDelegate?.dismiss()
            return
        }
        productDetailsDataManager.buyProduct(productUuid: product.uuid, buyerUuid: user.uuid, buyerName: user.username ?? "", sellerUuid: product.ownerUuid ?? "", sellerName: product.ownerName ?? "", price: product.price ?? 0.0, productName: product.title ?? "") { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.viewDelegate?.dismissLoadingAlert()
            }
            else {
                self.showErrorMessage()
            }
        }
    }
    
    func deleteButtonTapped() {
        productDetailsDataManager.deleteProduct(uuid: product.uuid) { [weak self] error in
            guard let self = self else { return }
            if error == nil {
                self.viewDelegate?.dismissLoadingAlert()
            }
            else {
                self.showErrorMessage()
            }
        }
    }
    
    func dismissViewController() {
        coordinatorDelegate?.dismiss()
    }
    
    private func showErrorMessage() {
        viewDelegate?.showErrorMessage(message: NSLocalizedString("product_details_upload_product_error_message", comment: ""))
    }
    
    func checkFields(title: String?, description: String?, price: String?) {
        guard let title = title, let description = description, let price = price, let priceValue = Double(price), let selectedCategoryId = selectedCategoryId, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            viewDelegate?.showErrorMessage(message: NSLocalizedString("product_details_empty_fields_error_message", comment: ""))
            return
        }
        checkImage(title: title, description: description, priceValue: priceValue, categoryId: selectedCategoryId, productUuid: product.uuid)
    }
    
    private func checkImage(title: String, description: String, priceValue: Double, categoryId: Int, productUuid: String) {
        if let imageData = coverImageData {
            productDetailsDataManager.updateImage(imageData: imageData) { [weak self] imageUrl, error in
                guard let self = self else { return }
                if error == nil, let imageUrl = imageUrl {
                    self.editProduct(title: title, description: description, priceValue: priceValue, categoryId: categoryId, productUuid: productUuid, coverImageUrl: imageUrl)
                }
                else {
                    self.showErrorMessage()
                }
            }
        }
        else {
            editProduct(title: title, description: description, priceValue: priceValue, categoryId: categoryId, productUuid: productUuid, coverImageUrl: product.coverImageUrl ?? "")
        }
    }
    
    private func editProduct(title: String, description: String, priceValue: Double, categoryId: Int, productUuid: String, coverImageUrl: String) {
        productDetailsDataManager.updateProduct(productUuid: productUuid, title: title, description: description, price: priceValue, categoryId: categoryId, coverImageUrl: coverImageUrl) { error in
            if error == nil {
                self.viewDelegate?.dismissLoadingAlert()
            }
            else {
                self.showErrorMessage()
            }
        }
    }
}
