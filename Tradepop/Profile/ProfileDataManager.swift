//
//  ProfileDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 10/10/21.
//

import Foundation

protocol ProfileDataManager{
    
    func getUserProducts(userUuid: String, completion: @escaping (Error?,[Product]?) -> ())
    
}
