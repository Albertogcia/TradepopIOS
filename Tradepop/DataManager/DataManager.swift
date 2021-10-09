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

extension DataManager: LoginRegisterDataManager{
    
}

extension DataManager: ProductsDataManager{
    
}
