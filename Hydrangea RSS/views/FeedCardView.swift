import SwiftUI

struct FeedCardView: View {
    var title: String?
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
            
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
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
