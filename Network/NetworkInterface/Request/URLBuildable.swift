//
//  URLBuildable.swift
//  Network
//
//  Created by 이상호 on 1/7/26.
//

import Foundation

public protocol URLBuildable {
    func addScheme(_ scheme: String) -> Self
    func addHost(_ host: String) -> Self
    func addPath(_ path: String) -> Self
    // Any로 했을 시 옵셔널 타입을 넘길 수 있어서 Any?으로 받는다.
    func addQuery(_ query: [String: Any?]) -> Self
    func build() -> URL?
}
