import Foundation
import UIKit

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
            let rssItem = RSSItem(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                link: link.trimmingCharacters(in: .whitespacesAndNewlines),
                description: attributedDescription,
                pubDate: pubDate.trimmingCharacters(in: .whitespacesAndNewlines),
                generator: author.trimmingCharacters(in: .whitespacesAndNewlines),
                imageURL: imageURL.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            items.append(rssItem)
        }
    }
}

extension String {
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
