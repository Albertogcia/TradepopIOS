//
//  ProductCell.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 11/10/21.
//

import Kingfisher
import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var viewModel: ProductCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            priceLabel.text = viewModel.productPrice
            descriptionLabel.text = viewModel.productTitle
            downloadImage(stringUrl: viewModel.productImageUrl)
        }
    }
    
    override func prepareForReuse() {
        productImage.image = nil
        priceLabel.text = nil
        descriptionLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 20
        mainView.layer.borderColor = UIColor.secondaryColor.cgColor
        mainView.layer.borderWidth = 1
    }

    private func downloadImage(stringUrl: String?) {
        guard let stringUrl = stringUrl, let url = URL(string: stringUrl) else {
            productImage.image = UIImage(named: "no_image_placeholder")?.withTintColor(.primaryColor)
            return
        }
        productImage.kf.setImage(with: url, placeholder: nil, options: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(_):
                self.productImage.image = UIImage(named: "no_image_placeholder")?.withTintColor(.primaryColor)
            case .success(_):
                break
            }
        }
    }
}
