import Foundation
import SwiftUI
import UIKit

class RSSItem: ObservableObject, Identifiable, Codable {
    let id = UUID()

    @Published var title: String?
    @Published var link: String?
    @Published var description: NSAttributedString?
    @Published var pubDate: String?
    @Published var generator: String?
    @Published var imageURL: String?

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

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case description
        case pubDate
        case generator
        case imageURL
    }

    // Custom decoding to handle @Published properties and NSAttributedString
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        
        if let descriptionData = try container.decodeIfPresent(Data.self, forKey: .description) {
            self.description = try NSAttributedString(data: descriptionData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } else {
            self.description = nil
        }
        
        self.pubDate = try container.decodeIfPresent(String.self, forKey: .pubDate)
        self.generator = try container.decodeIfPresent(String.self, forKey: .generator)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
    }

    // Custom encoding to handle @Published properties and NSAttributedString
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(link, forKey: .link)
        
        if let description = description {
            let descriptionData = try description.data(from: NSRange(location: 0, length: description.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
            try container.encode(descriptionData, forKey: .description)
        }
        
        try container.encodeIfPresent(pubDate, forKey: .pubDate)
        try container.encodeIfPresent(generator, forKey: .generator)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
    }
}
