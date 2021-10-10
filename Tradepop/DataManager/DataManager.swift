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
    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.createNewProduct(imageData: imageData, title: title, description: description, categoryId: categoryId, price: price, userUuid: userUuid, userName: userName, completion: completion)
    }
}

extension DataManager: ProductsDataManager {}

extension DataManager: AddProductDataManager {}
