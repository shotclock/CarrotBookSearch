//
//  RouterError.swift
//  Base
//
//  Created by 이상호 on 1/9/26.
//

import Foundation

public enum RouterError: LocalizedError {
    case alreadyAttached
    case notAttached
    
    public var errorDescription: String? {
        switch self {
        case .alreadyAttached:
            return "이미 하위 라우터로 등록된 라우터 입니다."
        case .notAttached:
            return "현재 하위 라우터로 포함되어있지 않은 라우터 입니다."
        }
    }
}
