import Foundation

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension Int? {
    func toString() -> String {
        if let unwrappedInt = self {
            return String(unwrappedInt)
        } else {
            return "nil"
        }
    }
}
