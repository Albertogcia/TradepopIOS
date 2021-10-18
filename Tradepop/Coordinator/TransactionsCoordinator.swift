//
//  TransactionsCoordinator.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import UIKit

class TransactionsCoordinator: Coordinator{
    let presenter: UINavigationController
    let userDataManager: UserDataManager
    let transactionsDataManager: TransactionsDataManager
    
    init(presenter: UINavigationController, userDataManager: UserDataManager, transactionsDataManager: TransactionsDataManager){
        self.presenter = presenter
        self.userDataManager = userDataManager
        self.transactionsDataManager = transactionsDataManager
    }
    
    override func start() {
        let transactionsViewModel = TransactionsViewModel(userDataManager: userDataManager, transactionsDataManager: transactionsDataManager)
        let transactionsViewController = TransactionsViewController(viewModel: transactionsViewModel)
        transactionsViewModel.coordinatorDelegate = self
        transactionsViewModel.viewDelegate = transactionsViewController
        presenter.pushViewController(transactionsViewController, animated: false)
    }
    
    override func finish() {
        
    }
}

extension TransactionsCoordinator: TransactionsCoordinatorDelegate{
    func loginButtonTapped() {
        let loginRegisterCoordinator = LoginRegisterCoordinator(presenter: presenter, userDataManager: userDataManager)
        addChildCoordinator(loginRegisterCoordinator)
        loginRegisterCoordinator.start()
    }
}
