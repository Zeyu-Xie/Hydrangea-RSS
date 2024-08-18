import Foundation
import Combine

struct RSSList: Identifiable {
    
    // First Class - source
    let source: String
    
    // Second Class - data
    let id = UUID()
    let title: String?
    let link: String?
    let description: NSAttributedString?
    let lastBuildDate: String?
    let generator: String?
    let webMaster: String?
    let language: String?
    let ttl: Int?
    
    // Third Class - item list
    let list: [RSSItem]
    
    // Fourth Class - status
    let status: String
    
    // Method - load
    func load() {
        
    }
    
//    func renderAsList() -> FeedListView {
//        
//    }
}

class FeedListView: ObservableObject {
    
    @Published var items: [RSSItem] = []
    @Published private var selectedItem: String = ""

    func fetchRSSFeed() {
        
        items = []
        
        selectedItem = UserDefaults.standard.string(forKey: "selectedFeedSource") ?? ""
        
        guard let url = URL(string: selectedItem) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            self.parse(data: data)
        }.resume()
    }

    private func parse(data: Data) {
        let parser = XMLParser(data: data)
        let rssParserDelegate = RSSParserDelegate()
        parser.delegate = rssParserDelegate

        if parser.parse() {
            DispatchQueue.main.async {
                self.items = rssParserDelegate.items
            }
        }
    }
}
