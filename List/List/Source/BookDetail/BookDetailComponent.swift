//
//  BookDetailComponent.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import Base
import DomainInterface

public protocol BookDetailDependency: Dependency {
    var fetchBookDetailUsecase: FetchBookDetailUsecase { get }
}

public final class BookDetailComponent: Component<BookDetailDependency> {
}
