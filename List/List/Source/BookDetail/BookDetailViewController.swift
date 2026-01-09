//
//  BookDetailViewController.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import UIKit
import Base

// 뷰 컨트롤러 -> 뷰모델
protocol BookDetailViewControllerListener: AnyObject {
    
}

final class BookDetailViewController: UIViewController,
                                      BookDetailViewControllable,
                                      BookDetailViewControllerPresentable {
    // MARK: Definition
    struct UI {
        struct CoverImageView {
            static let size: CGSize = .init(width: 110,
                                            height: 150)
        }
        
        struct BodyStack {
            static let padding: NSDirectionalEdgeInsets = .init(top: 16,
                                                                leading: 16,
                                                                bottom: 20,
                                                                trailing: 16)
            static let spacing: CGFloat = 14
        }
        
        struct Divider {
            static let height: CGFloat = 1
        }
        
        static let stackSpacing: CGFloat = 6
    }
    
    // MARK: Properties
    weak var listener: BookDetailViewControllerListener?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let metaDataLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let openLinkButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "외부 브라우저로 열기"
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        
        setupScrollView()
        configureContentView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func configureContentView() {
        let headerStack = UIStackView(arrangedSubviews: [coverImageView, makeHeaderTextStack()])
        headerStack.axis = .horizontal
        headerStack.alignment = .top
        headerStack.spacing = 12
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let bodyStack = UIStackView(arrangedSubviews: [
            headerStack,
            makeDivider(),
            makeMetaDataStack(),
            makeDivider(),
            descLabel,
            openLinkButton
        ])
        bodyStack.axis = .vertical
        bodyStack.spacing = UI.BodyStack.spacing
        bodyStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bodyStack)
        
        NSLayoutConstraint.activate([
            coverImageView.widthAnchor.constraint(equalToConstant: UI.CoverImageView.size.width),
            coverImageView.heightAnchor.constraint(equalToConstant: UI.CoverImageView.size.height),
            
            bodyStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UI.BodyStack.padding.top),
            bodyStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.BodyStack.padding.leading),
            bodyStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UI.BodyStack.padding.trailing),
            bodyStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UI.BodyStack.padding.bottom)
        ])
    }
    
    private func makeHeaderTextStack() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, priceLabel, ratingLabel])
        stackView.axis = .vertical
        stackView.spacing = UI.stackSpacing
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    private func makeMetaDataStack() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [metaDataLabel])
        stackView.axis = .vertical
        stackView.spacing = UI.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    private func makeDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: UI.Divider.height)
        ])
        
        return view
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
}

