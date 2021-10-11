//
//  DataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 19/9/21.
//

import Foundation

class DataManager {

    let remoteDataManager: FirebaseDataManager

    init(remoteDataManager: FirebaseDataManager) {
        self.remoteDataManager = remoteDataManager
    }
}

extension DataManager: ProfileDataManager {
    func getUserProducts(userUuid: String, completion: @escaping (Error?, [Product]?) -> ()) {
        remoteDataManager.getUserProducts(userUuid: userUuid, completion: completion)
    }
}

extension DataManager: ProductsDataManager {
    func getAllProducts(completion: @escaping (Error?, [Product]?) -> ()) {
        remoteDataManager.getAllProducts(completion: completion)
    }
}

extension DataManager: AddProductDataManager {
    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.createNewProduct(imageData: imageData, title: title, description: description, categoryId: categoryId, price: price, userUuid: userUuid, userName: userName, completion: completion)
    }
}
