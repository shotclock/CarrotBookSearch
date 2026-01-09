//
//  BookListBuildable.swift
//  ListInterface
//
//  Created by 이상호 on 1/9/26.
//

import Base

public protocol BookListBuildable {
    func build(withListener listener: BookListListener?) -> any ViewableRoutable
}
