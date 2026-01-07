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
    func addQuery(_ query: [String: Any]) -> Self
    func build() -> URL?
}
