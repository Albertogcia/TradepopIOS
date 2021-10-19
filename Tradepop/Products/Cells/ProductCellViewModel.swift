//
//  ProductCellViewModel.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 11/10/21.
//

import Foundation

class ProductCellViewModel {
    let product: Product
    
    var productPrice: String?
    var productTitle: String?
    var productImageUrl: String?
    
    init(product: Product) {
        self.product = product
    
        self.productTitle = product.title
        self.productImageUrl = product.coverImageUrl
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        self.productPrice = "\(formatter.string(from: NSNumber(value: product.price ?? 0.0)) ?? "0")€"
    }
}
