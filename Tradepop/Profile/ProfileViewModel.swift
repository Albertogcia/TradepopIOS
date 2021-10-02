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
    func showNoUserView()
}

class ProfileViewModel{
    weak var coordinatorDelegate: ProfileCoordinatorDelegate?
    weak var viewDelegate: ProfileViewDelegate?
    
    let userDataManager: UserDataManager
    
    init(userDataManager: UserDataManager){
        self.userDataManager = userDataManager
    }
    
    func viewDidAppear(){
        
    }
    
    func viewWasLoaded(){
        
    }
    
    func loginButtonTapped(){
        coordinatorDelegate?.loginButtonTapped()
    }
}
