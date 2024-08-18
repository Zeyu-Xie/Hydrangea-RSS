import Foundation

extension NSAttributedString {
    func toString() -> String {
        return self.string
    }
}

extension NSAttributedString? {
    func toString() -> String {
        if let unwrappedNSAttributedString = self {
            return unwrappedNSAttributedString.string
        }
        else {
            return "nil"
        }
    }
}
