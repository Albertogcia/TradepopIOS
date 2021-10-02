//
//  UserDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 29/9/21.
//

import Foundation

class UserDataManager{
    let remoteDataManger: FirebaseUserDataManager
    
    init(remoteDataManger: FirebaseUserDataManager) {
        self.remoteDataManger = remoteDataManger
    }
}
