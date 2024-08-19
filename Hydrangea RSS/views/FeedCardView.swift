import SwiftUI

struct FeedCardView: View {
    
    @StateObject var rssItem: RSSItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL = rssItem.imageURL, let url = URL(string: imageURL) {
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
            
            if let title = rssItem.title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            if let author = rssItem.generator {
                Text("By \(author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let description = rssItem.description {
                Text(description.toString())
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            if let pubDate = rssItem.pubDate {
                Text(pubDate)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Link(destination: URL(string: rssItem.link!)!) {
                Text("Read more")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
