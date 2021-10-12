//
//  ProductsViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import UIKit

private let PRODUCT_CELL_IDENTIFIER = "ProductCell"

class ProductsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: UIControl.Event.valueChanged)
        return refreshControl
    }()

    let viewModel: ProductsViewModel

    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.getAllProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        navigationItem.backBarButtonItem?.tintColor = .secondaryColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        collectionView.refreshControl = refreshControl
        collectionView.register(UINib(nibName: PRODUCT_CELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: PRODUCT_CELL_IDENTIFIER)
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @objc private func refreshCollectionView() {
        viewModel.getAllProducts()
    }
}

extension ProductsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel.viewModel(at: indexPath) else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PRODUCT_CELL_IDENTIFIER, for: indexPath) as? ProductCell
        cell?.viewModel = viewModel
        return cell ?? UICollectionViewCell()
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 42) / 2
        let height = width + 72
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectItem(at: indexPath)
    }
}

extension ProductsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setTextToFilter(textToFilter: searchText)
    }
}

extension ProductsViewController: ProductsViewDelegate {
    func productsFetched() {
        indicatorView.isHidden = true
        refreshControl.isRefreshing ? refreshControl.endRefreshing() : nil
        collectionView.reloadData()
    }

    func showErrorMessage(message: String) {
        indicatorView.isHidden = true
        refreshControl.isRefreshing ? refreshControl.endRefreshing() : nil
        showErrorAlert(message: message)
    }
}
