//
//  ProfileViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 20/9/21.
//

import UIKit

private let PRODUCT_CELL_IDENTIFIER = "ProductCell"

class ProfileViewController: UIViewController {
    
    @IBOutlet var noUserView: NoUserView!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var myProductsLabel: UILabel!
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    let viewModel: ProfileViewModel
        
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        navigationItem.backBarButtonItem?.tintColor = .secondaryColor
        viewModel.viewWillAppear()
    }

    private func configureView() {
        myProductsLabel.text = NSLocalizedString("profile_my_products_label", comment: "")
        noUserView.onLogInButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.loginButtonTapped()
        }
        collectionView.refreshControl = refreshControl
        collectionView.register(UINib(nibName: PRODUCT_CELL_IDENTIFIER, bundle: nil), forCellWithReuseIdentifier: PRODUCT_CELL_IDENTIFIER)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        viewModel.logOut()
    }
    
    @objc func refreshCollectionView() {
        viewModel.getUserProducts()
    }
}

extension ProfileViewController: UICollectionViewDataSource {
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

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
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

extension ProfileViewController: ProfileViewDelegate {
    func productsFetched() {
        activityIndicatorView.isHidden = true
        refreshControl.isRefreshing ? refreshControl.endRefreshing() : nil
        collectionView.reloadData()
    }
    
    func showErrorMessage(message: String) {
        activityIndicatorView.isHidden = true
        refreshControl.isRefreshing ? refreshControl.endRefreshing() : nil
        showErrorAlert(message: message)
    }
    
    func updateView(user: User?) {
        if let user = user{
            noUserView.isHidden = true
            mainView.isHidden = false
            collectionView.reloadData()
            activityIndicatorView.isHidden = false
            userNameLabel.text = user.username
        }
        else{
            mainView.isHidden = true
            noUserView.isHidden = false
        }
    }
}
