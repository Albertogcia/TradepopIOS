//
//  TransactionTableViewCell.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var statusView: UIView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var productName: UILabel!
    
    var viewModel: TransactionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            priceLabel.text = viewModel.transactionsPrice
            productName.text = viewModel.productName
            statusView.backgroundColor = viewModel.isPurchase ? UIColor.red : UIColor.green
        }
    }
    
    override func prepareForReuse() {
        productName.text = nil
        priceLabel.text = nil
        statusView.backgroundColor = .clear
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
