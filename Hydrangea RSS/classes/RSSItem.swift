import Foundation
import SwiftUI
import UIKit
import URLImage

class RSSItem: Identifiable {
    
    // Variable - ID
    let id = UUID()
    
    // Variable - Data
    var title: String?
    var link: String?
    var description: NSAttributedString?
    var pubDate: String?
    var generator: String?
    var imageURL: String?
    
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
    
    // FeedCardView
    func renderAsCard() -> FeedCardView {
        return FeedCardView(
            title: self.title,
            link: self.link,
            description: self.description?.string ?? nil,
            pubDate: self.pubDate,
            author: self.generator,
            imageURL: self.imageURL
        )
    }
    
    // FeedContentView
    func renderAsContent() -> FeedContentView {
        return FeedContentView(
            title: self.title,
            link: self.link,
            description: self.description?.string ?? nil,
            pubDate: self.pubDate,
            author: self.generator,
            imageURL: self.imageURL
        )
    }
    
}






