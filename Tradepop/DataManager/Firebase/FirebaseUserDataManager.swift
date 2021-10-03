//
//  FirebaseUserDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 29/9/21.
//

import Foundation

protocol FirebaseUserDataManager {

    func registerNewUser(username: String, email: String, password: String, completion: @escaping ((Error?) -> ()))

    func loginUser(email: String, password: String, completion: @escaping ((Error?) -> ()))
    
    func logOut(completion: @escaping ((Bool) -> ()))

    func getCurrentUser(completion: @escaping ((User?) -> ()))
    
    func changePassword(email: String, completion: @escaping ((Error?) -> ()))
}
