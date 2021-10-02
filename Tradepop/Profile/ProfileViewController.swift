//
//  ProfileViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 20/9/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var noUserView: NoUserView!
    
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
        print("kkk WillAppear")
    }

    private func configureView() {
        noUserView.onLogInButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.loginButtonTapped()
        }
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func showNoUserView() {}
}
