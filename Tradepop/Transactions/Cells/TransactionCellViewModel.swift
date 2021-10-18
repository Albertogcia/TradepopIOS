//
//  TransactionCellViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import Foundation

class TransactionCellViewModel{
    let transaction: Transaction
    
    var transactionsPrice: String?
    var productName: String?
    var isPurchase: Bool
    
    init(transaction: Transaction){
        self.transaction = transaction
        
        self.productName = transaction.productName
        self.isPurchase = transaction.isPurchase
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        self.transactionsPrice = "\(formatter.string(from: NSNumber(value: transaction.price ?? 0.0)) ?? "0")€"
    }
}
