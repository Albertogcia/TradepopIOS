//
//  ProductDetailsViewController.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 11/10/21.
//

import Kingfisher
import MobileCoreServices
import Toucan
import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet var mainScroll: UIScrollView!
    
    @IBOutlet var imageTapGesture: UITapGestureRecognizer!
    @IBOutlet var coverImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categorySelectorView: UIView!
    @IBOutlet var categorySelectedLabel: UILabel!
    @IBOutlet var categoryTapGesture: UITapGestureRecognizer!
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet var buyButton: UIButton!
    
    @IBOutlet var editButtonsView: UIView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    let viewModel: ProductDetailsViewModel
    
    init(viewModel: ProductDetailsViewModel) {
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
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureView() {
        titleLabel.text = NSLocalizedString("product_details_title_label", comment: "")
        descriptionLabel.text = NSLocalizedString("product_details_description_label", comment: "")
        categoryLabel.text = NSLocalizedString("product_details_category_label", comment: "")
        categorySelectedLabel.text = NSLocalizedString("product_details_category_selected_label", comment: "")
        priceLabel.text = NSLocalizedString("product_details_price_label", comment: "")
        buyButton.setTitle(NSLocalizedString("product_details_buy_button", comment: ""), for: .normal)
        editButton.setTitle(NSLocalizedString("product_details_edit_button", comment: ""), for: .normal)
        deleteButton.setTitle(NSLocalizedString("product_details_delete_button", comment: ""), for: .normal)
        
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
        mainScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        mainScroll.contentInset = UIEdgeInsets.zero
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.mediaTypes = [(kUTTypeJPEG as String), (kUTTypeImage as String)]
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func categoryTapped(_ sender: Any) {
        showCategorySelectorAlert { [weak self] categoryId, categoryName in
            guard let self = self else { return }
            self.categorySelectedLabel.text = categoryName
            self.viewModel.selectCategory(categoryId: categoryId)
        }
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        showLoadingAlert()
        viewModel.buyButtonTapped()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        showLoadingAlert()
        viewModel.checkFields(title: titleTextField.text, description: descriptionTextView.text, price: priceTextField.text)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        showDeleteAlert(title: NSLocalizedString("product_details_delete_product_title", comment: ""), message: NSLocalizedString("product_details_delete_product_message", comment: ""), deleteButtonMessage: NSLocalizedString("generic_delete", comment: ""), cancelButtonMessage: NSLocalizedString("generic_cancel", comment: "")) { [weak self] _ in
            guard let self = self else { return }
            self.showLoadingAlert()
            self.viewModel.deleteButtonTapped()
        }
    }
}

extension ProductDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            coverImage.image = image
            let resizedImage = Toucan(image: image).resize(CGSize(width: 1280, height: 1280), fitMode: Toucan.Resize.FitMode.clip)
            viewModel.selectImage(imageData: resizedImage.image?.jpegData(compressionQuality: 1))
        }
    }
}

extension ProductDetailsViewController: ProductDetailsViewDelegate {
    func dismissLoadingAlert() {
        hideLoadingAlert { [weak self] in
            guard let self = self else { return }
            self.viewModel.dismissViewController()
        }
    }
    
    func showErrorMessage(message: String) {
        hideLoadingAlert { [weak self] in
            guard let self = self else { return }
            self.showErrorAlert(message: message)
        }
    }
    
    func updateView() {
        titleTextField.text = viewModel.productTitleText
        descriptionTextView.text = viewModel.productDescriptionText
        categorySelectedLabel.text = viewModel.productCategoryString
        priceTextField.text = viewModel.productPriceText
        
        downloadImage(stringUrl: viewModel.imageUrl)
        
        if viewModel.showEditButtons {
            editButtonsView.isHidden = false
            titleTextField.isEnabled = true
            descriptionTextView.isEditable = true
            priceTextField.isEnabled = true
            imageTapGesture.isEnabled = true
            categoryTapGesture.isEnabled = true
        }
    
        buyButton.isHidden = !viewModel.showBuyButton
    }
    
    private func downloadImage(stringUrl: String?) {
        guard let stringUrl = stringUrl, let url = URL(string: stringUrl) else {
            coverImage.image = UIImage(named: "no_image_placeholder")?.withTintColor(.primaryColor)
            return
        }
        coverImage.kf.setImage(with: url, placeholder: nil, options: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.coverImage.image = UIImage(named: "no_image_placeholder")?.withTintColor(.primaryColor)
            case .success:
                break
            }
        }
    }
}
