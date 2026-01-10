//
//  BookListComponent.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Base
import BookListInterface
import DomainInterface

public protocol BookListDependency: Dependency {
    var searchBookUsecase: SearchBookUsecase { get }
}

public final class BookListComponent: Component<BookListDependency> {
    var bookDetailBuilder: BookDetailBuilder {
        .init(dependency: self)
    }
}

extension BookListComponent: BookDetailDependency {
    
}
