//
//  FavoritesDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 17/10/21.
//

import Foundation

protocol FavoritesDataManager{
    
    func getProductsFromUserFavorites(userUuid: String, completion: @escaping (Error?, [Product]?) -> ())

}
