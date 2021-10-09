//
//  ProductsViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import UIKit

class ProductsViewController: UIViewController {
    
    let viewModel: ProductsViewModel
    
    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProductsViewController: ProductsViewDelegate{
    
}
