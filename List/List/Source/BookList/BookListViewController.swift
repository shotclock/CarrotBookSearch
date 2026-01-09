//
//  BookListViewController.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import UIKit
import Base

// 뷰 컨트롤러 -> 뷰모델
protocol BookListViewControllerListener: AnyObject {
    func didRequestSearch(keyword: String)
}

final class BookListViewController: UIViewController,
                                    BookListViewControllable,
                                    BookListViewControllerPresentable {
    // MARK: Definition
    struct UI {
        struct LogoImageView {
            static let topPadding: CGFloat = 10
            static let size: CGSize = .init(width: 100,
                                            height: 100)
        }
        
        struct SearchTextField {
            static let topSpacing: CGFloat = 10
            static let horizontalPadding: CGFloat = 15
        }
    }
    
    // MARK: Properties
    weak var listener: BookListViewControllerListener?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(resource: .logo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "검색어를 입력하세요 !"
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()

    // MARK: initializer
    deinit {
        print(#fileID, #line, #function)
    }
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: UI setting
    private func setupUI() {
        view.backgroundColor = .white
        
        setupLogoImageView()
        setupSearchTextField()
    }
    
    private func setupLogoImageView() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UI.LogoImageView.topPadding),
            logoImageView.widthAnchor.constraint(equalToConstant: UI.LogoImageView.size.width),
            logoImageView.heightAnchor.constraint(equalToConstant: UI.LogoImageView.size.height)
        ])
    }
    
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: UI.SearchTextField.topSpacing),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UI.SearchTextField.horizontalPadding),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UI.SearchTextField.horizontalPadding)
        ])
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
}

extension BookListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text ?? ""
        listener?.didRequestSearch(keyword: keyword)
        
        return true
    }
}
