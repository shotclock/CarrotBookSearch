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
    public let publishYear: String
    public let rating: String

    public let description: String
    public let price: String

    public let imageURL: String
    public let linkURL: String
    
    public let pdfData: [String: String]?

    public init(
        title: String,
        subtitle: String,
        authors: String,
        publisher: String,
        language: String,
        isbn10: String,
        isbn13: String,
        pages: String,
        publishYear: String,
        rating: String,
        description: String,
        price: String,
        imageURL: String,
        linkURL: String,
        pdfData: [String: String]?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.publisher = publisher
        self.language = language
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.pages = pages
        self.publishYear = publishYear
        self.rating = rating
        self.description = description
        self.price = price
        self.imageURL = imageURL
        self.linkURL = linkURL
        self.pdfData = pdfData
    }
}
