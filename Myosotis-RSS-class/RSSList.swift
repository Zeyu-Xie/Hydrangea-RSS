import Foundation

class RSSList: Codable {
    
    init(name: String, list: [RSSItem]) {
        self.name = name
        self.list = list
    }
    
    var name: String
    var list: [RSSItem]
    
    func encode() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            let jsonStr = String(data: data, encoding: .utf8)!
            return jsonStr
        } catch let err {
            return err.localizedDescription
        }
    }
}
