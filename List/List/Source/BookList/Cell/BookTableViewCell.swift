//
//  BookTableViewCell.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    // MARK: Definition
    static let reuseIdentifier = String(describing: BookTableViewCell.self)
    
    struct UI {
        struct BookImageView {
            static let size: CGSize = .init(width: 60,
                                            height: 90)
            static let horizontalPadding: CGFloat = 12
        }
        
        struct LabelsStackView {
            static let spacing: CGFloat = 2
            static let padding: NSDirectionalEdgeInsets = .init(top: 8,
                                                                leading: 12,
                                                                bottom: 8,
                                                                trailing: 12)
        }
        
        struct Fonts {
            static let title: UIFont = .systemFont(ofSize: 17,
                                                   weight: .bold)
            static let subtitle: UIFont = .systemFont(ofSize: 13,
                                                      weight: .medium)
            static let isbn13: UIFont = .systemFont(ofSize: 10,
                                                    weight: .regular)
            static let price: UIFont = .systemFont(ofSize: 14,
                                                   weight: .medium)
            static let url: UIFont = .systemFont(ofSize: 13,
                                                 weight: .regular)
        }
    }
    
    // MARK: Properties
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UI.Fonts.title
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UI.Fonts.subtitle
        
        return label
    }()
    
    private let isbn13Label: UILabel = {
        let label = UILabel()
        label.font = UI.Fonts.isbn13
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Fonts.price
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Fonts.url
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = UI.LabelsStackView.spacing
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    // MARK: Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        isbn13Label.text = nil
        priceLabel.text = nil
        urlLabel.text = nil
    }
    
    // MARK: UI setting
    private func setupUI() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(labelsStackView)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)
        labelsStackView.addArrangedSubview(isbn13Label)
        labelsStackView.addArrangedSubview(priceLabel)
        labelsStackView.addArrangedSubview(urlLabel)
        
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.BookImageView.horizontalPadding),
            bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: UI.BookImageView.size.width),
            bookImageView.heightAnchor.constraint(equalToConstant: UI.BookImageView.size.height),
            
            labelsStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: UI.LabelsStackView.padding.leading),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UI.LabelsStackView.padding.top),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UI.LabelsStackView.padding.trailing),
            labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -UI.LabelsStackView.padding.bottom)
        ])
    }
    
    func configure(data: DummyBook) {
        titleLabel.text = data.title
        subtitleLabel.text = "서브타이틀 영역"
        isbn13Label.text = "ISBN13: 12314412312"
        priceLabel.text = "$ 4.73"
        urlLabel.text = "www.google.com"
        
        bookImageView.image = .logo
    }
}
