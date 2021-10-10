//
//  ProfileViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 20/9/21.
//

import Foundation

protocol ProfileCoordinatorDelegate: AnyObject {
    func loginButtonTapped()
}

protocol ProfileViewDelegate: AnyObject{
    func updateView(user: User?)
}

class ProfileViewModel{
    weak var coordinatorDelegate: ProfileCoordinatorDelegate?
    weak var viewDelegate: ProfileViewDelegate?
    
    let userDataManager: UserDataManager
    let profileDataManager: ProfileDataManager
    
    init(userDataManager: UserDataManager, profileDataManager: ProfileDataManager){
        self.userDataManager = userDataManager
        self.profileDataManager = profileDataManager
    }
    
    func viewWillAppear(){
        userDataManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            self.viewDelegate?.updateView(user: user)
        }
    }
        
    func loginButtonTapped(){
        coordinatorDelegate?.loginButtonTapped()
    }
    
    func logOut(){
        userDataManager.logOut { successful in
            self.viewDelegate?.updateView(user: nil)
        }
    }
}
