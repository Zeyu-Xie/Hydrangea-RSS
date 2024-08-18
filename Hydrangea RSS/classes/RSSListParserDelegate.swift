import Foundation
import Combine

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var rssListItems: [RSSItem] = []
    var isParsingItems: Bool = false
    
    var rssListCoreData: RSSListCoreData = RSSListCoreData()
    
    var currentElement: String = ""
    var currentTitle: String = ""
    var currentLink: String = ""
    var currentDescription: String = ""
    var currentPubDate: String = ""
    var currentAuthor: String = ""
    var currentImageURL: String = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            isParsingItems = true
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
            currentAuthor = ""
            currentImageURL = ""
        }
        
        else if elementName == "itunes:image" {
            if isParsingItems {
                currentImageURL = attributeDict["href"]!
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isParsingItems {
            switch currentElement {
            case "title":
                currentTitle = string
            case "link":
                currentLink = string
            case "description":
                currentDescription += string
            case "pubDate":
                currentPubDate = string
            case "author":
                currentAuthor = string
            default:
                break
            }
        }
        else {
            switch currentElement {
            case "title":
                rssListCoreData.title = string
            case "link":
                rssListCoreData.link = string
            case "description":
                rssListCoreData.description = string
            case "generator":
                rssListCoreData.generator = string
            case "webMaster":
                rssListCoreData.webMaster = string
            case "language":
                rssListCoreData.language = string
            case "lastBuildDate":
                rssListCoreData.lastBuildDate = string
            case "ttl":
                rssListCoreData.ttl = string
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "items" {
            isParsingItems = false
        }
        
        if isParsingItems {
            if elementName == "item" {
                let rssItem = RSSItem(
                    title: currentTitle.trimmed()!,
                    link: currentLink.trimmed(),
                    description: currentDescription.htmlToAttributedString(),
                    pubDate: currentPubDate.trimmed(),
                    generator: currentAuthor.trimmed(),
                    imageURL: currentImageURL.trimmed()
                )
                rssListItems.append(rssItem)
            }
        }
    }
}
