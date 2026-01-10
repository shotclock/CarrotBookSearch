//
//  BookListComponent.swift
//  List
//
//  Created by 이상호 on 1/9/26.
//

import Base
import BookListInterface

public protocol BookListDependency: Dependency {
    
}

public final class BookListComponent: Component<BookListDependency> {
    var bookDetailBuilder: BookDetailBuilder {
        .init(dependency: self)
    }
}

extension BookListComponent: BookDetailDependency {
    
}
