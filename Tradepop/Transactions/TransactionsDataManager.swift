//
//  TransactionsDataManager.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import Foundation

protocol TransactionsDataManager {
    
    func getUserTransactions(userUuid: String, completion: @escaping (Error?, [Transaction]?) -> ())
    
}
