//
//  TransactionsViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 18/10/21.
//

import UIKit

private let TRANSACTION_CELL_IDENTIFIER = "TransactionTableViewCell"

class TransactionsViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!

    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var noUserView: NoUserView!
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryColor
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    let viewModel: TransactionsViewModel
    
    init(viewModel: TransactionsViewModel) {
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
        viewModel.viewWillAppear()
    }
    
    private func configureView(){
        noUserView.onLogInButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.loginButtonTapped()
        }
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.register(UINib(nibName: TRANSACTION_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: TRANSACTION_CELL_IDENTIFIER)
        tableView.dataSource = self
    }

    @objc func refreshTableView() {
        viewModel.getTransactions()
    }

}

extension TransactionsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel.viewModel(at: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: TRANSACTION_CELL_IDENTIFIER, for: indexPath) as? TransactionTableViewCell
        cell?.viewModel = viewModel
        return cell ?? UITableViewCell()
    }
}

extension TransactionsViewController: TransactionsViewDelegate{
    func transactionsFetched() {
        activityIndicatorView.isHidden = true
        refreshControl.isRefreshing ? refreshControl.endRefreshing() : nil
        tableView.reloadData()
    }

    func showErrorMessage(message: String) {
        activityIndicatorView.isHidden = true
        refreshControl.isRefreshing ? refreshControl.endRefreshing() : nil
        showErrorAlert(message: message)
    }

    func updateView(user: User?) {
        if user != nil {
            noUserView.isHidden = true
            mainView.isHidden = false
            activityIndicatorView.isHidden = true
        }
        else {
            mainView.isHidden = true
            noUserView.isHidden = false
        }
    }
}
