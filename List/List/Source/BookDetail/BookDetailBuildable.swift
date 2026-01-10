//
//  BookDetailBuildable.swift
//  BookList
//
//  Created by 이상호 on 1/10/26.
//

import Base

public protocol BookDetailBuildable {
    func build(withListener listener: BookDetailListener?,
               isbn13: String) -> any ViewableRoutable
}
