import Foundation
import Combine

class RSSFeedViewModel: ObservableObject {
    @Published var items: [RSSItem] = []

    func fetchRSSFeed() {
        guard let url = URL(string: "https://rsshub.app/caixin/article") else { return }
        
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
