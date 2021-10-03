//
//  UserDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 29/9/21.
//

import Foundation

class UserDataManager {
    let remoteDataManger: FirebaseUserDataManager
    
    init(remoteDataManger: FirebaseUserDataManager) {
        self.remoteDataManger = remoteDataManger
    }
    
    func registerNewUser(username: String, email: String, password: String, completion: @escaping ((Error?) -> ())) {
        remoteDataManger.registerNewUser(username: username, email: email, password: password, completion: completion)
    }
    
    func loginUser(email: String, password: String, completion: @escaping ((Error?) -> ())) {
        remoteDataManger.loginUser(email: email, password: password, completion: completion)
    }
    
    func getCurrentUser(completion: @escaping ((User?) -> ())) {
        remoteDataManger.getCurrentUser(completion: completion)
    }
    
    func logOut(completion: @escaping ((Bool) -> ())){
        remoteDataManger.logOut(completion: completion)
    }
    
    func changePassword(email: String, completion: @escaping ((Error?) -> ())){
        remoteDataManger.changePassword(email: email, completion: completion)
    }
}
