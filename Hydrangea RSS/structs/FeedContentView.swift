import Foundation
import Combine

class FeedContentView: ObservableObject {
    
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
