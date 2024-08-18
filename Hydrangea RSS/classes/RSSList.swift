import Foundation
import Combine

class RSSList: ObservableObject, Identifiable {
    
    // First Class - source
    @Published var source: String
    
    // Second Class - data
    let id = UUID()
    @Published var title: String?
    @Published var link: String?
    @Published var description: NSAttributedString?
    @Published var lastBuildDate: String?
    @Published var generator: String?
    @Published var webMaster: String?
    @Published var language: String?
    @Published var ttl: Int?
    
    // Third Class - item list
    @Published var list: [RSSItem]
    
    // Fourth Class - status
    @Published var isLoading: Bool
    
    // Init
    init(source: String) {
        self.source = source
        self.title = ""
        self.link = ""
        self.description = NSAttributedString("")
        self.lastBuildDate = ""
        self.generator = ""
        self.webMaster = ""
        self.language = ""
        self.ttl = 0
        self.list = []
        self.isLoading = false
    }
    
    // Method - to string
    func toString() -> String {
        var resultString = ""
        resultString += "Source: \(self.source.toString())\n"
        resultString += "ID: \(self.id.toString())\n"
        resultString += "Title: \(self.title.toString())\n"
        resultString += "Link: \(self.link.toString())\n"
        resultString += "Description: \(self.description.toString())\n"
        resultString += "LastBuildDate: \(self.lastBuildDate.toString())\n"
        resultString += "Generator: \(self.generator.toString())\n"
        resultString += "WebMaster: \(self.webMaster.toString())\n"
        resultString += "Language: \(self.language.toString())\n"
        resultString += "TTL: \(self.ttl.toString())"
        for item in self.list {
            resultString += "\n---\n"
            resultString += item.toString()
        }
        return resultString
    }
    
    // Method - load
    func load(completion: @escaping () -> Void) {
        self.isLoading = true
    
        guard let url = URL(string: self.source) else {
            self.isLoading = false
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Failed
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Failed to load data: \(error?.localizedDescription ?? "Unknown error")")
                    completion()
                }
                return
            }
            
            // Successful
            DispatchQueue.main.async {
                parse(data: data) { result, cd in
                    self.list = result
                    self.title = cd.title
                    self.link = cd.link
                    self.description = cd.description?.htmlToAttributedString()
                    self.lastBuildDate = cd.lastBuildDate
                    self.generator = cd.generator
                    self.webMaster = cd.webMaster
                    self.language = cd.language
                    self.ttl = Int(cd.ttl ?? "0")
                    self.isLoading = false
                    completion()
                }
            }
            
        }.resume()
    }
}

func parse(data: Data, completion: @escaping ([RSSItem], coreData) -> Void) {
    let parser = XMLParser(data: data)
    let rssParserDelegate = RSSParserDelegate()
    parser.delegate = rssParserDelegate
    
    if parser.parse() {
        DispatchQueue.main.async {
            let resultArray = rssParserDelegate.items
            let cd = rssParserDelegate.cd
            completion(resultArray, cd)
        }
    } else {
        completion([], coreData())
    }
}

struct coreData {
    var title: String = ""
    var link: String? = nil
    var description: String? = nil
    var generator: String? = nil
    var webMaster: String? = nil
    var language: String? = nil
    var lastBuildDate: String? = nil
    var ttl: String? = nil
}

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var items: [RSSItem] = []
    var isParsingItems: Bool = false
    
    var cd: coreData = coreData()
    
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
        }
        
        if isParsingItems {
            // 处理 <items> 内部的标签
            switch elementName {
            case "title":
                currentTitle = ""
            case "link":
                currentLink = ""
            case "description":
                currentDescription = ""
            case "pubDate":
                currentPubDate = ""
            case "author":
                currentAuthor = ""
            case "itunes:image":
                currentImageURL = attributeDict["href"] ?? ""
            default:
                break
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isParsingItems {
            switch currentElement {
            case "title":
                currentTitle += string
            case "link":
                currentLink += string
            case "description":
                currentDescription += string
            case "pubDate":
                currentPubDate += string
            case "author":
                currentAuthor += string
            default:
                break
            }
        }
        else {
            switch currentElement {
            case "title":
                cd.title = string
            case "link":
                cd.link = string
            case "description":
                cd.description = string
            case "generator":
                cd.generator = string
            case "webMaster":
                cd.webMaster = string
            case "language":
                cd.language = string
            case "lastBuildDate":
                cd.lastBuildDate = string
            case "ttl":
                cd.ttl = string
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
                let attributedDescription = currentDescription.htmlToAttributedString()
                let rssItem = RSSItem(
                    title: currentTitle.trimmed()!,
                    link: currentLink.trimmed(),
                    description: attributedDescription,
                    pubDate: currentPubDate.trimmed(),
                    generator: currentAuthor.trimmed(),
                    imageURL: currentImageURL.trimmed()
                )
                items.append(rssItem)
            }
        }
    }
}
