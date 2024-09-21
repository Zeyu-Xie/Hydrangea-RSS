import Foundation

class RSSItem: ObservableObject, Codable {
    
    init(jsonStr: String) {
        let data = jsonStr.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let rssItem = try decoder.decode(RSSItem.self, from: data)
            self.url = rssItem.url
        } catch let err {
            self.url = URL(string: err.localizedDescription)!
        }
    }
    
    init(url_str: String) {
        self.url = URL(string: url_str)!
    }
    init(url: URL) {
        self.url = url
    }
    
    var url: URL
    
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
