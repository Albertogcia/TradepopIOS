//
//  ProfileViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 20/9/21.
//

import Foundation

protocol ProfileCoordinatorDelegate: AnyObject {
    func loginButtonTapped()
}

protocol ProfileViewDelegate: AnyObject{
    func productsFetched()
    func showErrorMessage(message: String)
    func updateView(user: User?)
}

class ProfileViewModel{
    weak var coordinatorDelegate: ProfileCoordinatorDelegate?
    weak var viewDelegate: ProfileViewDelegate?
    
    let userDataManager: UserDataManager
    let profileDataManager: ProfileDataManager
    
    var productViewModels: [ProductCellViewModel] = []
    
    var previousUserUuid: String = ""
    
    init(userDataManager: UserDataManager, profileDataManager: ProfileDataManager){
        self.userDataManager = userDataManager
        self.profileDataManager = profileDataManager
    }
    
    func viewWillAppear(){
        userDataManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            if let user = user{
                if self.previousUserUuid != user.uuid{
                    self.previousUserUuid = user.uuid
                    self.productViewModels = []
                    self.viewDelegate?.updateView(user: user)
                    self.getUserProducts()
                }
            }
            else{
                self.viewDelegate?.updateView(user: nil)
            }
        }
    }
    
    func getUserProducts(){
        if previousUserUuid.isEmpty { return }
        profileDataManager.getUserProducts(userUuid: previousUserUuid) { error, products in
            if error == nil, let products = products{
                self.productViewModels = products.map({ product in
                    return ProductCellViewModel(product: product)
                })
                self.viewDelegate?.productsFetched()
            }
            else{
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("products_error_fetching_products", comment: ""))
            }
        }
    }
        
    func loginButtonTapped(){
        coordinatorDelegate?.loginButtonTapped()
    }
    
    func logOut(){
        previousUserUuid = ""
        userDataManager.logOut { [weak self] successful in
            guard let self = self else { return }
            self.viewDelegate?.updateView(user: nil)
        }
    }
        
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int{
        return productViewModels.count
    }
    
    func viewModel(at indexPath: IndexPath) -> ProductCellViewModel? {
        guard indexPath.row < productViewModels.count else { return nil }
        return productViewModels[indexPath.row]
    }
}
