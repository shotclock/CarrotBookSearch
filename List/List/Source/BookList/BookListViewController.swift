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
    func didSelectBook(_ book: DummyBook)
}

enum Section {
    case main
}

struct DummyBook: Hashable {
    let id = UUID()
    let title: String
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
        
        struct BookListTableView {
            static let verticalSpacing: CGFloat = 50
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
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let bookListTableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var diffableDataSource: UITableViewDiffableDataSource<Section, DummyBook> = {
        .init(tableView: bookListTableView) { [weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier, for: indexPath) as? BookTableViewCell
            
            cell?.configure(data: itemIdentifier)
            
            return cell
        }
    }()

    // MARK: initializer
    deinit {
        print(#fileID, #line, #function)
    }
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 테스트 스냅샷
        var snapshot = NSDiffableDataSourceSnapshot<Section, DummyBook>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.init(title: "1"), .init(title: "2"), .init(title: "3"), .init(title: "4"), .init(title: "5"), .init(title: "6") ,.init(title: "7")])
        
        diffableDataSource.apply(snapshot)
    }
    
    // MARK: UI setting
    private func setupUI() {
        view.backgroundColor = .white
        
        setupLogoImageView()
        setupSearchTextField()
        setupTableView()
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
    
    private func setupTableView() {
        view.addSubview(bookListTableView)
        bookListTableView.delegate = self
        bookListTableView.rowHeight = UITableView.automaticDimension
        bookListTableView.dataSource = diffableDataSource
        bookListTableView.register(BookTableViewCell.self,
                                   forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            bookListTableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: UI.BookListTableView.verticalSpacing),
            bookListTableView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            bookListTableView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            bookListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UI.BookListTableView.verticalSpacing)
        ])
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
}

// MARK: UITextFieldDelegate
extension BookListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text ?? ""
        listener?.didRequestSearch(keyword: keyword)
        
        return true
    }
}

// MARK: UITableViewDelegate
extension BookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bookData = diffableDataSource.snapshot().itemIdentifiers[safe: indexPath.row] else {
            return
        }
        
        listener?.didSelectBook(bookData)
    }
}
