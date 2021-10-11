//
//  Product.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 10/10/21.
//

import Foundation
import Firebase

struct Product{
    var uuid: String
    var title: String?
    var description: String?
    var price: Double?
    var categoryId: Int?
    var ownerUuid: String?
    var ownerName: String?
    var date: Date?
    var coverImageUrl: String?
    
    static func parseDataFromFirebase(document: QueryDocumentSnapshot) -> Product{
        let documentData = document.data()
        let documentUuid = document.documentID
        let title = documentData["title"] as? String
        let description = documentData["description"] as? String
        let price = documentData["price"] as? Double
        let categoryId = documentData["categoryId"] as? Int
        let ownerUuid = documentData["owner"] as? String
        let ownerName = documentData["ownerName"] as? String
        let date = (documentData["date"] as? Timestamp)?.dateValue()
        let coverImageUrl = documentData["coverImageUrl"] as? String
        return Product(uuid: documentUuid, title: title, description: description, price: price, categoryId: categoryId, ownerUuid: ownerUuid, ownerName: ownerName, date: date, coverImageUrl: coverImageUrl)
    }
}
