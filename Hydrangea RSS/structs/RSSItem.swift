import Foundation
import SwiftUI
import UIKit
import URLImage

struct RSSItem: Identifiable {
    let id = UUID()
    var title: String
    var link: String
    var description: NSAttributedString?
    var pubDate: String?
    var generator: String?
    var imageURL: String?
    
    func renderAsCard() -> FeedCardView {
        return FeedCardView(
            title: self.title,
            link: self.link,
            description: self.description?.string,
            pubDate: self.pubDate,
            author: self.generator,
            imageURL: self.imageURL
        )
    }
    
    func renderAsContent() -> FeedContentView {
        return FeedContentView(
            title: self.title,
            link: self.link,
            description: self.description?.string,
            pubDate: self.pubDate,
            author: self.generator,
            imageURL: self.imageURL
        )
    }
    
}

struct HTMLTextView: UIViewRepresentable {
    let html: NSAttributedString
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = html
    }
}

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var items: [RSSItem] = []
    private var currentElement = ""
    private var title = ""
    private var link = ""
    private var _description = ""
    private var pubDate = ""
    private var author = ""
    private var imageURL = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            title = ""
            link = ""
            _description = ""
            pubDate = ""
            author = ""
            imageURL = ""
        }
        if currentElement == "itunes:image" {
            imageURL = attributeDict["href"] ?? ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            title += string
        case "link":
            link += string
        case "description":
            _description += string
        case "pubDate":
            pubDate += string
        case "author":
            author += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let attributedDescription = _description.htmlToAttributedString() ?? NSAttributedString(string: _description)
            var rssItem = RSSItem(
                title: title.trimmed!,
                link: link.trimmed!,
                description: attributedDescription,
                pubDate: pubDate.trimmed,
                generator: author.trimmed,
                imageURL: imageURL.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            items.append(rssItem)
        }
    }
}

extension String {
    
    var trimmed: String? {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.isEmpty ? nil : trimmedString
    }
    
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
    }
}

struct FeedCardView: View {
    var title: String
    var link: String
    var description: String?
    var pubDate: String?
    var author: String?
    var imageURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let author = author {
                Text("By \(author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let description = description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            if let pubDate = pubDate {
                Text(pubDate)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Link(destination: URL(string: link)!) {
                Text("Read more")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemGray6)))
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .padding(.vertical, 5)
    }
}

struct FeedContentView: View {
    var title: String
    var link: String?
    var description: String?
    var pubDate: String?
    var author: String?
    var imageURL: String?
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageURL = imageURL, let url = URL(string: imageURL) {
                        URLImage(url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .clipped()
                        }
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let author = author {
                            Text("By \(author)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        if let description = description {
                            Text(description)
                                .font(.body)
                                .padding(.top, 8)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if let pubDate = pubDate {
                            Text(pubDate)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        if let link = link, let url = URL(string: link) {
                            Link("Read Original Article", destination: url)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
