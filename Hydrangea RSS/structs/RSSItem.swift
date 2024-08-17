import Foundation

struct RSSItem: Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let description: NSAttributedString
    let pubDate: String
    let generator: String
    let imageURL: String
}
