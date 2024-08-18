import Foundation
import SwiftUI
import UIKit
import URLImage

class RSSItem: Identifiable {
    
    // Variable - ID
    let id = UUID()
    
    // Variable - Data
    var title: String
    var link: String?
    var description: NSAttributedString?
    var pubDate: String?
    var generator: String?
    var imageURL: String?
    
    // Function - init
    init(title: String, link: String? = nil, description: NSAttributedString? = nil, pubDate: String? = nil, generator: String? = nil, imageURL: String? = nil) {
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


struct FeedCardView: View {
    var title: String
    var link: String?
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
            
            Link(destination: URL(string: link!)!) {
                Text("Read more")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
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
