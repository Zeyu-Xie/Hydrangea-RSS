import Foundation

struct RSSItem: Identifiable {
    let id = UUID()
    let title: String
    let description: NSAttributedString
    let pubDate: String
}
