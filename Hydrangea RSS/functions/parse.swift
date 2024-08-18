import Foundation

func parse(data: Data, completion: @escaping ([RSSItem], RSSListCoreData) -> Void) {
    let parser = XMLParser(data: data)
    let rssParserDelegate = RSSParserDelegate()
    parser.delegate = rssParserDelegate
    
    if parser.parse() {
        DispatchQueue.main.async {
            let resultArray = rssParserDelegate.rssListItems
            let cd = rssParserDelegate.rssListCoreData
            completion(resultArray, cd)
        }
    } else {
        completion([], RSSListCoreData())
    }
}
