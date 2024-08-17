import SwiftUI
import URLImage

struct FeedContentView: View {
    var title: String
    var link: String?
    var description: String?
    var pubDate: String?
    var author: String?
    var imageURL: String?
    
    var body: some View {
        VStack(alignment: .center) {
            NavigationStack {
                ScrollView {
                    if let imageURL = imageURL, let url = URL(string: imageURL) {
                        URLImage(url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(title).font(.title).padding(.vertical)
                        if (author != nil) {
                            Text(author!).foregroundStyle(.secondary).font(.subheadline)
                        }
                        if (description != nil) {
                            Text(description!)
                        }
                        Divider()
                        if (pubDate != nil) {
                            HStack {
                                Spacer()
                                Text(pubDate!).foregroundStyle(.secondary).font(.subheadline)
                            }
                        }
                        if (link != nil) {
                            HStack {
                                Spacer()
                                Link(destination: URL(string: link!)!) {
                                    Text("Read Origin").font(.subheadline)
                                }
                            }
                        }
                    }.padding(.horizontal)
                }.navigationTitle(self.title).navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
