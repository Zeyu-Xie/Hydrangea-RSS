import Foundation
import Combine

class RSSList: ObservableObject, Identifiable {
    
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
    
    // Method - to string
    func toString() -> String {
        var resultString = ""
        resultString += "Source: \(self.source.toString())\n"
        resultString += "ID: \(self.id.toString())\n"
        resultString += "Title: \(self.title.toString())\n"
        resultString += "Link: \(self.link.toString())\n"
        resultString += "Description: \(self.description.toString())\n"
        resultString += "LastBuildDate: \(self.lastBuildDate.toString())\n"
        resultString += "Generator: \(self.generator.toString())\n"
        resultString += "WebMaster: \(self.webMaster.toString())\n"
        resultString += "Language: \(self.language.toString())\n"
        resultString += "TTL: \(self.ttl.toString())"
        for item in self.list {
            resultString += "\n---\n"
            resultString += item.toString()
        }
        return resultString
    }
    
    // Method - load
    func load(completion: @escaping () -> Void) {
        self.isLoading = true
    
        guard let url = URL(string: self.source) else {
            self.isLoading = false
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Failed
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Failed to load data: \(error?.localizedDescription ?? "Unknown error")")
                    completion()
                }
                return
            }
            
            // Successful
            DispatchQueue.main.async {
                parse(data: data) { result, cd in
                    self.list = result
                    self.title = cd.title
                    self.link = cd.link
                    self.description = cd.description?.htmlToAttributedString()
                    self.lastBuildDate = cd.lastBuildDate
                    self.generator = cd.generator
                    self.webMaster = cd.webMaster
                    self.language = cd.language
                    self.ttl = Int(cd.ttl ?? "0")
                    self.isLoading = false
                    completion()
                }
            }
            
        }.resume()
    }
}
