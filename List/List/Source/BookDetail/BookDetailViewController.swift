//
//  BookDetailViewController.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import UIKit
import Base
import DomainInterface

// 뷰 컨트롤러 -> 뷰모델
protocol BookDetailViewControllerListener: AnyObject {
    func didTapOpenLinkButton(with url: String)
}

final class BookDetailViewController: UIViewController,
                                      BookDetailViewControllable {
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
        
        struct PDFSection {
            static let spacing: CGFloat = 10
        }
        
        struct PDFButton {
            static let imagePdding: CGFloat = 8
            static let contentInset: NSDirectionalEdgeInsets = .init(top: 6,
                                                                     leading: 0,
                                                                     bottom: 6,
                                                                     trailing: 0)
        }
        
        static let stackSpacing: CGFloat = 6
    }
    
    // MARK: Properties
    weak var listener: BookDetailViewControllerListener?
    private var bookData: BookDetail?
    
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
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pdfSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "PDF"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let pdfLinksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = UI.PDFSection.spacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
            descriptionLabel,
            makeDivider(),
            makePDFSection(),
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
        
        openLinkButton.addTarget(self,
                                 action: #selector(didTapOpenLinkButton),
                                 for: .touchUpInside)
    }
    
    private func makeHeaderTextStack() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       subtitleLabel,
                                                       priceLabel,
                                                       ratingLabel])
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
    
    private func makePDFSection() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [pdfSectionTitleLabel,
                                                       pdfLinksStackView])
        stackView.axis = .vertical
        stackView.spacing = UI.stackSpacing
        stackView.alignment = .fill
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
    
    private func makePDFButtons(entries: Array<(key: String, value: String)>) -> [UIButton] {
        entries.map { (title: String, link: String) in
            var config = UIButton.Configuration.plain()
            config.title = title
            config.image = UIImage(systemName: "doc.richtext")
            config.imagePadding = UI.PDFButton.imagePdding
            config.contentInsets = UI.PDFButton.contentInset

            let button = UIButton(configuration: config)
            button.contentHorizontalAlignment = .leading
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let action = UIAction { [weak self] _ in
                self?.listener?.didTapOpenLinkButton(with: link)
            }
            
            button.addAction(action,
                             for: .touchUpInside)
            
            return button
        }
    }
    
    // MARK: Public methods
    
    // MARK: Private methods
    @objc
    private func didTapOpenLinkButton() {
        guard let url = bookData?.linkURL else {
            return
        }
        
        listener?.didTapOpenLinkButton(with: url)
    }
}

// MARK: BookDetailViewControllerPresentable
extension BookDetailViewController: BookDetailViewControllerPresentable {
    func updateBookDetail(to data: BookDetail) {
        bookData = data
        
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle.isEmpty ? nil : data.subtitle
        metaDataLabel.text = [
            "Authors: \(data.authors)",
            "Publisher: \(data.publisher)",
            "Language: \(data.language)",
            "ISBN-10: \(data.isbn10)",
            "ISBN-13: \(data.isbn13)",
            "Pages: \(data.pages)",
            "Year: \(data.publishYear)"
        ].joined(separator: "\n")
        
        priceLabel.text = data.price
        ratingLabel.text = data.rating
        descriptionLabel.text = data.description
        
        pdfLinksStackView.arrangedSubviews.forEach { view in
            pdfLinksStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let pdfEntries = (data.pdfData ?? [:]).sorted { $0.key.localizedStandardCompare($1.key) == .orderedAscending }

        let hasPDF = pdfEntries.isEmpty == false
        pdfSectionTitleLabel.isHidden = !hasPDF
        pdfLinksStackView.isHidden = !hasPDF
        
        guard hasPDF else {
            return
        }
        
        makePDFButtons(entries: pdfEntries).forEach {
            pdfLinksStackView.addArrangedSubview($0)
        }
    }
    
    func presentError(description: String) {
        let alert = UIAlertController(
            title: "알림",
            message: description,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
