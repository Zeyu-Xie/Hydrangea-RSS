import Foundation

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
