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
        label.font = .systemFont(ofSize: 17,
                                 weight: .bold)
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13,
                                 weight: .medium)
        
        return label
    }()
    
    private let isbn13Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10,
                                 weight: .regular)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,
                                 weight: .medium)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13,
                                 weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
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
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: 60),
            bookImageView.heightAnchor.constraint(equalToConstant: 90),
            
            labelsStackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 12),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            labelsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
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
