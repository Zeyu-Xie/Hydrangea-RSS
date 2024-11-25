import Foundation
import Combine

class RSSList: ObservableObject, Identifiable, Codable {
    
    // First Class - source
    @Published var source: String
    
    // Second Class - data
    let id = UUID()
    @Published var title: String? = nil
    @Published var link: String? = nil
    @Published var description: NSAttributedString? = nil
    @Published var lastBuildDate: String? = nil
    @Published var generator: String? = nil
    @Published var webMaster: String? = nil
    @Published var language: String? = nil
    @Published var ttl: Int? = nil
    
    // Third Class - item list
    @Published var list: [RSSItem] = []
    
    // Fourth Class - status
    @Published var isLoading: Bool = false
    
    // Init
    init(source: String) {
        self.source = source
    }
    
    // Codable keys
    private enum CodingKeys: String, CodingKey {
        case source, title, link, lastBuildDate, generator, webMaster, language, ttl, list
    }
    
    // Decode
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(String.self, forKey: .source)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        lastBuildDate = try container.decodeIfPresent(String.self, forKey: .lastBuildDate)
        generator = try container.decodeIfPresent(String.self, forKey: .generator)
        webMaster = try container.decodeIfPresent(String.self, forKey: .webMaster)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        ttl = try container.decodeIfPresent(Int.self, forKey: .ttl)
        list = try container.decode([RSSItem].self, forKey: .list)
    }
    
    // Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(lastBuildDate, forKey: .lastBuildDate)
        try container.encodeIfPresent(generator, forKey: .generator)
        try container.encodeIfPresent(webMaster, forKey: .webMaster)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(ttl, forKey: .ttl)
        try container.encode(list, forKey: .list)
    }
    
    // Method - to string
    func toString() -> String {
        var resultString = ""
        resultString += "Source: \(self.source)\n"
        resultString += "ID: \(self.id)\n"
        resultString += "Title: \(self.title ?? "nil")\n"
        resultString += "Link: \(self.link ?? "nil")\n"
        resultString += "Description: \(self.description?.string ?? "nil")\n"
        resultString += "LastBuildDate: \(self.lastBuildDate ?? "nil")\n"
        resultString += "Generator: \(self.generator ?? "nil")\n"
        resultString += "WebMaster: \(self.webMaster ?? "nil")\n"
        resultString += "Language: \(self.language ?? "nil")\n"
        resultString += "TTL: \(self.ttl?.description ?? "nil")"
        for item in self.list {
            resultString += "\n---\n"
            resultString += item.toString()
        }
        return resultString
    }
    
    // Method - load
    func load(completion: @escaping () -> Void) {
        self.isLoading = true
        
        guard let sourceURL = URL(string: self.source) else {
            self.isLoading = false
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: sourceURL) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Failed to load data: \(error?.localizedDescription ?? "Unknown error")")
                    completion()
                }
                return
            }
            
            DispatchQueue.main.async {
                parse(data: data) { rssListItems, rssListCoreData in
                    self.list = rssListItems
                    self.title = rssListCoreData.title
                    self.link = rssListCoreData.link
                    self.description = rssListCoreData.description?.toNSAttributedString()
                    self.lastBuildDate = rssListCoreData.lastBuildDate
                    self.generator = rssListCoreData.generator
                    self.webMaster = rssListCoreData.webMaster
                    self.language = rssListCoreData.language
                    self.ttl = Int(rssListCoreData.ttl ?? "0")
                    self.isLoading = false
                    completion()
                }
            }
            
        }.resume()
    }
}
