//
//  Transaction.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import Firebase
import Foundation

struct Transaction {
    var uuuid: String
    var buyerName: String?
    var buyerUuid: String?
    var price: Double?
    var productName: String?
    var sellerName: String?
    var sellerUuid: String?
    var date: Date?
    var isPurchase: Bool

    static func parseDataFromFirebase(document: QueryDocumentSnapshot, userUuid: String) -> Transaction {
        let documentData = document.data()
        let uuid = document.documentID
        let buyerName = documentData["buyerName"] as? String
        let buyerUuid = documentData["buyerUuid"] as? String
        let price = documentData["price"] as? Double
        let productName = documentData["productName"] as? String
        let sellerName = documentData["sellerName"] as? String
        let sellerUuid = documentData["sellerUuid"] as? String
        let date = (documentData["date"] as? Timestamp)?.dateValue()
        let isPurchase = (userUuid == buyerUuid)
        return Transaction(uuuid: uuid, buyerName: buyerName, buyerUuid: buyerUuid, price: price, productName: productName, sellerName: sellerName, sellerUuid: sellerUuid, date: date, isPurchase: isPurchase)
    }
}
