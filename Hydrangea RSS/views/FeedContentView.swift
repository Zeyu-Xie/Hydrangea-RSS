import SwiftUI
import URLImage

struct FeedContentView: View {
    var title: String?
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
                        
                        if let title = title {
                            Text(title)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
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
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
