//
//  BookDetail.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import Foundation

public struct BookDetail: Hashable {
    public let isbn13: String
    public let title: String
    public let subtitle: String?
    public let authors: String
    public let publisher: String
    public let desc: String
    public let priceText: String
    public let imageURL: URL?
    public let linkURL: URL?
    
    public init(isbn13: String,
                title: String,
                subtitle: String?,
                authors: String,
                publisher: String,
                desc: String,
                priceText: String,
                imageURL: URL?,
                linkURL: URL?) {
        self.isbn13 = isbn13
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.publisher = publisher
        self.desc = desc
        self.priceText = priceText
        self.imageURL = imageURL
        self.linkURL = linkURL
    }
}
