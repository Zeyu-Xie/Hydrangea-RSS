import Foundation
import Combine

class RSSList: Identifiable {
    
    // First Class - source
    var source: String = ""
    
    // Second Class - data
    let id = UUID()
    var title: String = ""
    var link: String? = nil
    var description: String? = nil
    var lastBuildDate: String? = nil
    var generator: String? = nil
    var webMaster: String? = nil
    var language: String? = nil
    var ttl: Int? = 0
    
    // Third Class - item list
    var list: [RSSItem] = []
    
    // Fourth Class - status
    var isLoading: Bool = false
    
    // Method - to string
    func toString() -> String {
        var resultString = ""
        resultString += "Source: \(self.source.toString())\n"
        resultString += "ID: \(self.id.uuidString)\n"
        resultString += "Title: \(self.title)\n"
        resultString += "Link: \(self.link ?? "nil")\n"
        resultString += "Description: \(self.description ?? "nil")\n"
        resultString += "LastBuildDate: \(self.lastBuildDate ?? "nil")\n"
        resultString += "Generator: \(self.generator ?? "nil")\n"
        resultString += "WebMaster: \(self.webMaster ?? "nil")\n"
        resultString += "Language: \(self.language ?? "nil")\n"
        resultString += "TTL: \(self.ttl.toString())"
        for item in self.list {
            resultString += "\n---\n"
            resultString += item.toString()
        }
        return resultString
    }
    
    // 修改 load 方法接受一个完成闭包
    func load(completion: @escaping () -> Void) {
        self.isLoading = true
        
        guard let url = URL(string: self.source) else {
            self.isLoading = false
            completion()
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Failed to load data: \(error?.localizedDescription ?? "Unknown error")")
                    completion()
                }
                return
            }

            // 在主线程中解析数据
            DispatchQueue.main.async {
                self.parse(data: data, completion: {
                    self.isLoading = false
                    completion()
                })

            }
        }.resume()
    }

    func parse(data: Data, completion: @escaping () -> Void) {
        let parser = XMLParser(data: data)
        let rssParserDelegate = RSSParserDelegate()
        parser.delegate = rssParserDelegate
        if parser.parse() {
            DispatchQueue.main.async {
                self.list = rssParserDelegate.items
                completion()
            }
        }
    }
}

class FeedListView: ObservableObject {
    
    @Published var items: [RSSItem] = []
    @Published private var selectedItem: String = ""
    
    var rssList = RSSList()
    
    func fetchRSSFeed() {
        rssList.source = UserDefaults.standard.string(forKey: "selectedFeedSource")!
        rssList.load(completion: { [self] in
            print(rssList.toString())
        })
        
    }
    
}
