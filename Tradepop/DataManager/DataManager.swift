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
    func getAllProducts(userUuid: String?, completion: @escaping (Error?, [Product]?) -> ()) {
        remoteDataManager.getAllProducts(userUuid: userUuid, completion: completion)
    }
}

extension DataManager: AddProductDataManager {
    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.createNewProduct(imageData: imageData, title: title, description: description, categoryId: categoryId, price: price, userUuid: userUuid, userName: userName, completion: completion)
    }
}

extension DataManager: ProductDetailsDataManager {

    func addToFavorites(productUuid: String, userUuid: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.addToFavorites(productUuid: productUuid, userUuid: userUuid, completion: completion)
    }

    func removeFromFavorites(productUuid: String, userUuid: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.removeFromFavorites(productUuid: productUuid, userUuid: userUuid, completion: completion)
    }

    func deleteProduct(uuid: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.deleteProduct(uuid: uuid, completion: completion)
    }

    func buyProduct(productUuid: String, buyerUuid: String, buyerName: String, sellerUuid: String, sellerName: String, price: Double, productName: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.buyProduct(productUuid: productUuid, buyerUuid: buyerUuid, buyerName: buyerName, sellerUuid: sellerUuid, sellerName: sellerName, price: price, productName: productName, completion: completion)
    }

    func updateProduct(productUuid: String, title: String, description: String, price: Double, categoryId: Int, coverImageUrl: String, completion: @escaping (Error?) -> ()) {
        remoteDataManager.updateProduct(productUuid: productUuid, title: title, description: description, price: price, categoryId: categoryId, coverImageUrl: coverImageUrl, completion: completion)
    }

    func updateImage(imageData: Data, completion: @escaping (String?, Error?) -> ()) {
        remoteDataManager.updateImage(imageData: imageData, completion: completion)
    }

    func getUserFavorites() -> [String] {
        return remoteDataManager.getUserFavorites()
    }
}

extension DataManager: FavoritesDataManager {

    func getProductsFromUserFavorites(userUuid: String, completion: @escaping (Error?, [Product]?) -> ()) {
        remoteDataManager.getProductsFromUserFavorites(userUuid: userUuid, completion: completion)
    }
}

extension DataManager: TransactionsDataManager {

    func getUserTransactions(userUuid: String, completion: @escaping (Error?, [Transaction]?) -> ()) {
        remoteDataManager.getUserTransactions(userUuid: userUuid, completion: completion)
    }
}
