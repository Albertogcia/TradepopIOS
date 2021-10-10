//
//  AddProductDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import Foundation

protocol AddProductDataManager {
    
    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ())
    
}
