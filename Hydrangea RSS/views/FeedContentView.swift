import SwiftUI
import URLImage

struct FeedContentView: View {
    
    @StateObject var rssItem: RSSItem
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageURL = rssItem.imageURL, let url = URL(string: imageURL) {
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
                        
                        if let title = rssItem.title {
                            Text(title)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        if let author = rssItem.generator {
                            Text("By \(author)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        if let description = rssItem.description {
                            Text(description.toString())
                                .font(.body)
                                .padding(.top, 8)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if let pubDate = rssItem.pubDate {
                            Text(pubDate)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        
                        if let link = rssItem.link, let url = URL(string: link) {
                            Link("Read Original Article", destination: url)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(rssItem.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
