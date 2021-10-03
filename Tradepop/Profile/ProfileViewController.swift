//
//  ProfileViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 20/9/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var noUserView: NoUserView!
    
    @IBOutlet var mainView: UIView!
    
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
        viewModel.viewWillAppear()
    }

    private func configureView() {
        noUserView.onLogInButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.loginButtonTapped()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        viewModel.logOut()
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func updateView(user: User?) {
        if let user = user{
            noUserView.isHidden = true
            mainView.isHidden = false
        }
        else{
            mainView.isHidden = true
            noUserView.isHidden = false
        }
    }
}
