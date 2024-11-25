import Foundation

extension NSAttributedString {
    func toString() -> String {
        return self.string
    }
    func toOptionalString() -> String? {
        return Optional(self.string)
    }
}

extension NSAttributedString? {
    func toString() -> String {
        if self != nil {
            if let unwrappedNSAttributedString = self {
                return unwrappedNSAttributedString.string
            }
            else {
                return "nil"
            }
        }
        else {
            return "nil"
        }
    }
    func toOptionalString() -> String? {
        if self != nil {
            if let unwrappedNSAttributedString = self {
                return unwrappedNSAttributedString.string
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}
