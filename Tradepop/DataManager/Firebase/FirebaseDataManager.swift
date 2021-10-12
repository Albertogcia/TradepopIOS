//
//  FirebaseDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 30/9/21.
//

import Foundation

protocol FirebaseDataManager{
    
    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ())
    
    func getAllProducts(userUuid: String?, completion: @escaping (Error?, [Product]?) -> ())
    
    func getUserProducts(userUuid: String, completion: @escaping (Error?, [Product]?) -> ())
    
    func deleteProduct(uuid: String, completion: @escaping (Error?) -> ())
    
    func buyProduct(productUuid: String, buyerUuid: String, buyerName: String,  sellerUuid: String, sellerName: String, price: Double, productName: String, completion: @escaping (Error?) -> ())
    
    func updateImage(imageData: Data, completion: @escaping (String?, Error?) -> ())
    
    func updateProduct(productUuid: String, title: String, description: String, price: Double, categoryId: Int, coverImageUrl: String, completion: @escaping (Error?) -> ())
}
