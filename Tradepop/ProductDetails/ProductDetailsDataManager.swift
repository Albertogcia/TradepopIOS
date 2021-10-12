//
//  ProductDetailsDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 11/10/21.
//

import Foundation

protocol ProductDetailsDataManager {
    
    func deleteProduct(uuid: String, completion: @escaping (Error?) -> ())
    
    func buyProduct(productUuid: String, buyerUuid: String, buyerName: String,  sellerUuid: String, sellerName: String, price: Double, productName: String, completion: @escaping (Error?) -> ())
    
    func updateProduct(productUuid: String, title: String, description: String, price: Double, categoryId: Int, coverImageUrl: String, completion: @escaping (Error?) -> ())
    
    func updateImage(imageData: Data, completion: @escaping (String?, Error?) -> ())

}
