//
//  FirebaseDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 30/9/21.
//

import Foundation

protocol FirebaseDataManager{
    
    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ())
    
}
