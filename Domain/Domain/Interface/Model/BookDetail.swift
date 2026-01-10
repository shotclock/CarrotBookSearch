//
//  BookDetail.swift
//  Domain
//
//  Created by 이상호 on 1/10/26.
//

import Foundation

public struct BookDetail: Equatable, Sendable {
    public let title: String
    public let subtitle: String

    public let authors: String
    public let publisher: String
    public let language: String

    public let isbn10: String
    public let isbn13: String

    public let pages: String
    public let year: String
    public let rating: String

    public let desc: String
    public let price: String

    public let image: URL
    public let url: URL
    
    public let pdf: [String: URL]?

    public init(
        title: String,
        subtitle: String,
        authors: String,
        publisher: String,
        language: String,
        isbn10: String,
        isbn13: String,
        pages: String,
        year: String,
        rating: String,
        desc: String,
        price: String,
        image: URL,
        url: URL,
        pdf: [String: URL]?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.publisher = publisher
        self.language = language
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.pages = pages
        self.year = year
        self.rating = rating
        self.desc = desc
        self.price = price
        self.image = image
        self.url = url
        self.pdf = pdf
    }
}
