//
//  BookSummary.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import Foundation

public struct BookSummary: Hashable {
    public let isbn13: String
    public let title: String
    public let subtitle: String
    public let priceText: String
    public let imageURL: URL?
    public let detailURLString: String
    
    public init(isbn13: String,
                title: String,
                subtitle: String,
                priceText: String,
                imageURL: URL?,
                detailURLString: String) {
        self.isbn13 = isbn13
        self.title = title
        self.subtitle = subtitle
        self.priceText = priceText
        self.imageURL = imageURL
        self.detailURLString = detailURLString
    }
}
