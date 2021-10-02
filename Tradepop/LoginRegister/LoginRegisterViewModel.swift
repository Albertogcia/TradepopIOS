//
//  LoginRegisterViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 24/9/21.
//

import Foundation

protocol LoginRegisterCoordinatorDelegate: AnyObject {
    
}

protocol LoginRegisterViewDelegate: AnyObject{
    func showErrorMessage(message: String)
}

class LoginRegisterViewModel{
    weak var coordinatorDelegate: LoginRegisterCoordinatorDelegate?
    weak var viewDelegate: LoginRegisterViewDelegate?
    
    let userDataManager: UserDataManager
    let loginRegisterDataManager: LoginRegisterDataManager
    
    init(userDataManager: UserDataManager, loginRegisterDataManager: LoginRegisterDataManager){
        self.userDataManager = userDataManager
        self.loginRegisterDataManager = loginRegisterDataManager
    }
    
    func checkLoginFields(email: String?, password: String?){
        
    }
    
    func checkRegisterFields(userName: String?, email: String?, password: String?){
        
    }
    
    func closeButtonTapped(){
        
    }
    
    func loginButtonTapped(){
        
    }
    
    func registerButtonTapped(){
        
    }
}
