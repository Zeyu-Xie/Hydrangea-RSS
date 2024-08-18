//
//  extensions_String.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/18.
//

import Foundation

extension String {
    func toString() -> String {
        return self
    }
    func trimmed() -> String? {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.isEmpty ? nil : trimmedString
    }
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
    }
}

extension String? {
    func toString() -> String {
        if let unwrappedString = self {
            return unwrappedString
        }
        else {
            return "nil"
        }
    }
    func trimmed() -> String? {
        if let unwrappedString = self {
            let trimmedString = unwrappedString.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedString.isEmpty ? nil : trimmedString
        }
        else {
            return nil
        }
    }
    func htmlToAttributedString() -> NSAttributedString? {
        if let unwrappedString = self {
            return unwrappedString.htmlToAttributedString()
        }
        else {
            return nil
        }
    }
}
