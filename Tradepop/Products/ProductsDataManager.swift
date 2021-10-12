//
//  ProductsDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import Foundation

protocol ProductsDataManager{
    
    func getAllProducts(userUuid: String?, completion: @escaping (Error?, [Product]?) -> ())
}
