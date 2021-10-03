//
//  FirebaseUserDataManagerImp.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 29/9/21.
//

import Firebase
import Foundation

class FirebaseUserDataManagerImp: FirebaseUserDataManager {

    func registerNewUser(username: String, email: String, password: String, completion: @escaping ((Error?) -> ())) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                guard let currentUser = authResult?.user else { completion(error); return }
                let changeUserDataRequest = currentUser.createProfileChangeRequest()
                changeUserDataRequest.displayName = username
                changeUserDataRequest.commitChanges { error in
                    completion(error)
                }
            }
            else {
                completion(error)
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping ((Error?) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }
    
    func logOut(completion: @escaping ((Bool) -> ())){
        do{
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            completion(false)
        }
    }

    func getCurrentUser(completion: @escaping ((User?) -> ())) {
        let currentUser = Auth.auth().currentUser
        if let currentUser = currentUser {
            let user = User(uuid: currentUser.uid, username: currentUser.displayName, email: currentUser.email)
            completion(user)
        }
        else {
            completion(nil)
        }
    }
    
    func changePassword(email: String, completion: @escaping ((Error?) -> ())) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
