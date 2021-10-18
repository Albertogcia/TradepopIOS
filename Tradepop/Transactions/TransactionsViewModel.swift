//
//  TransactionsViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import Foundation

protocol TransactionsCoordinatorDelegate: AnyObject {
    func loginButtonTapped()
}

protocol TransactionsViewDelegate: AnyObject {
    func transactionsFetched()
    func showErrorMessage(message: String)
    func updateView(user: User?)
}

class TransactionsViewModel {
    
    weak var coordinatorDelegate: TransactionsCoordinatorDelegate?
    weak var viewDelegate: TransactionsViewDelegate?
    
    let userDataManager: UserDataManager
    let transactionsDataManager: TransactionsDataManager
    
    var transactionViewModels: [TransactionCellViewModel] = []
    
    var previousUserUuid: String = ""
    
    init(userDataManager: UserDataManager, transactionsDataManager: TransactionsDataManager) {
        self.userDataManager = userDataManager
        self.transactionsDataManager = transactionsDataManager
    }
    
    func viewWillAppear() {
        userDataManager.getCurrentUser { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                self.viewDelegate?.updateView(user: user)
                if self.previousUserUuid != user.uuid {
                    self.previousUserUuid = user.uuid
                    self.transactionViewModels = []
                    self.getTransactions()
                }
            }
            else {
                self.viewDelegate?.updateView(user: nil)
            }
        }
    }
    
    func getTransactions(){
        if previousUserUuid.isEmpty { return }
        transactionsDataManager.getUserTransactions(userUuid: previousUserUuid) { [weak self] error, transactions in
            guard let self = self else { return }
            if error == nil, let transactions = transactions {
                self.transactionViewModels = transactions.map { transaction in
                    TransactionCellViewModel(transaction: transaction)
                }
                self.viewDelegate?.transactionsFetched()
            }
            else {
                self.viewDelegate?.showErrorMessage(message: NSLocalizedString("products_error_fetching_products", comment: ""))
            }
        }
    }
    
    func loginButtonTapped(){
        coordinatorDelegate?.loginButtonTapped()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return transactionViewModels.count
    }
    
    func viewModel(at indexPath: IndexPath) -> TransactionCellViewModel? {
        guard indexPath.row < transactionViewModels.count else { return nil }
        return transactionViewModels[indexPath.row]
    }
}
