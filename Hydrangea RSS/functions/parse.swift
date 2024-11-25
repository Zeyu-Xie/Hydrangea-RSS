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
                    title: currentTitle.toOptionalString()!,
                    link: currentLink.toOptionalString(),
                    description: currentDescription.toNSAttributedString(),
                    pubDate: currentPubDate.toOptionalString(),
                    generator: currentAuthor.toOptionalString(),
                    imageURL: currentImageURL.toOptionalString()
                )
                rssListItems.append(rssItem)
            }
        }
    }
}


func parse(data: Data, completion: @escaping ([RSSItem], RSSListCoreData) -> Void) {
    
    let parser = XMLParser(data: data)
    let rssParserDelegate = RSSParserDelegate()
    parser.delegate = rssParserDelegate
    
    if parser.parse() {
        DispatchQueue.main.async {
            let rssListItems = rssParserDelegate.rssListItems
            let rssListCoreData = rssParserDelegate.rssListCoreData
            completion(rssListItems, rssListCoreData)
        }
    } else {
        completion([], RSSListCoreData())
    }
}

struct RSSListCoreData {
    var title: String? = nil
    var link: String? = nil
    var description: String? = nil
    var generator: String? = nil
    var webMaster: String? = nil
    var language: String? = nil
    var lastBuildDate: String? = nil
    var ttl: String? = nil
}
