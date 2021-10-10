//
//  AddProductViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 9/10/21.
//

import MobileCoreServices
import Toucan
import UIKit

class AddProductViewController: UIViewController {
    
    @IBOutlet var noUserView: NoUserView!
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var coverCameraImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categorySelectorView: UIView!
    @IBOutlet var categorySelectedLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet var uploadButton: UIButton!
    
    let viewModel: AddProductViewModel
    
    init(viewModel: AddProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
    }
    
    private func configureView() {
        noUserView.onLogInButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.loginButtonTapped()
        }
        
        titleLabel.text = NSLocalizedString("add_product_title_label", comment: "")
        descriptionLabel.text = NSLocalizedString("add_product_description_label", comment: "")
        categoryLabel.text = NSLocalizedString("add_product_category_label", comment: "")
        categorySelectedLabel.text = NSLocalizedString("add_product_category_selected_label", comment: "")
        priceLabel.text = NSLocalizedString("add_product_price_label", comment: "")
        uploadButton.setTitle(NSLocalizedString("add_product_upload_button", comment: ""), for: .normal)
        
        titleTextField.layer.borderColor = UIColor.secondaryColor.cgColor
        titleTextField.layer.borderWidth = 1
        
        descriptionTextView.layer.borderColor = UIColor.secondaryColor.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.contentInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        
        categorySelectorView.layer.borderColor = UIColor.secondaryColor.cgColor
        categorySelectorView.layer.borderWidth = 1
        
        priceTextField.layer.borderColor = UIColor.secondaryColor.cgColor
        priceTextField.layer.borderWidth = 1
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        mainScrollView.contentInset = UIEdgeInsets.zero
    }

    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        showLoadingAlert()
        viewModel.checkFields(title: titleTextField.text, description: descriptionTextView.text, price: priceTextField.text)
    }
    
    @IBAction func coverImageTapped(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.mediaTypes = [(kUTTypeJPEG as String), (kUTTypeImage as String)]
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func categoryGestureTapped(_ sender: Any) {
        showCategorySelectorAlert { [weak self] categoryId, categoryName in
            guard let self = self else { return }
            self.categorySelectedLabel.text = categoryName
            self.viewModel.selectCategory(categoryId: categoryId)
        }
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            coverImage.image = image
            coverCameraImage.isHidden = true
            let resizedImage = Toucan(image: image).resize(CGSize(width: 1280, height: 1280), fitMode: Toucan.Resize.FitMode.clip)
            viewModel.selectImage(imageData: resizedImage.image?.jpegData(compressionQuality: 1))
        }
    }
}

extension AddProductViewController: AddProductViewDelegate {
    func updateView(user: User?) {
        if user == nil {
            mainScrollView.isHidden = true
            noUserView.isHidden = false
        } else {
            noUserView.isHidden = true
            mainScrollView.isHidden = false
        }
    }
    
    func showErrorMessage(message: String) {
        hideLoadingAlert { [weak self] in
            guard let self = self else { return }
            self.showErrorAlert(message: message)
        }
    }
    
    func clearView() {
        hideLoadingAlert()
        categorySelectedLabel.text = NSLocalizedString("add_product_category_selected_label", comment: "")
        titleTextField.text = nil
        descriptionTextView.text = ""
        priceTextField.text = nil
        coverImage.image = nil
        coverCameraImage.isHidden = false
        self.resignFirstResponder()
    }
}
