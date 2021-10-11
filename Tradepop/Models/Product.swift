//
//  Product.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 10/10/21.
//

import Foundation

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
}
