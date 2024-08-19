import Foundation
import SwiftUI
import UIKit
import URLImage

class RSSItem: ObservableObject, Identifiable {
    
    // Variable - ID
    let id = UUID()
    
    // Variable - Data
    @Published var title: String?
    @Published var link: String?
    @Published var description: NSAttributedString?
    @Published var pubDate: String?
    @Published var generator: String?
    @Published var imageURL: String?
    
    // Function - init
    init(
        title: String? = nil,
        link: String? = nil,
        description: NSAttributedString? = nil,
        pubDate: String? = nil,
        generator: String? = nil,
        imageURL: String? = nil
    ) {
        self.title = title
        self.link = link
        self.description = description
        self.pubDate = pubDate
        self.generator = generator
        self.imageURL = imageURL
    }
    
    // Function - toString
    func toString() -> String {
        var resultString = ""
        resultString += "ID: \(self.id.toString())\n"
        resultString += "Title: \(self.title.toString())\n"
        resultString += "Link: \(self.link.toString())\n"
        resultString += "PubDate: \(self.pubDate.toString())\n"
        resultString += "Generator: \(self.generator.toString())\n"
        resultString += "ImageURL: \(self.imageURL.toString())\n"
        resultString += "Description: \(self.description.toString())"
        return resultString
    }
}
