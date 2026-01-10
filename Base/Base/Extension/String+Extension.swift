//
//  String+Extension.swift
//  Base
//
//  Created by 이상호 on 1/11/26.
//

import UIKit

public extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        let decoded = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ).string

        return decoded ?? self
    }
}
