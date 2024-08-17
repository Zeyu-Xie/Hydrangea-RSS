import SwiftUI
import URLImage

struct FeedLabelView: View {
    var title: String
    var link: String?
    var description: String?
    var pubDate: String?
    var author: String?
    var imageURL: String?
    
    var body: some View {
        VStack(alignment: .center) {
            
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                URLImage(url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            HStack {
                VStack {
                    Text(title).bold()
                    if (link != nil) {
                        Text(link!)
                    }
                    if (pubDate != nil) {
                        Text(pubDate!)
                    }
                    if (author != nil) {
                        Text(author!)
                    }
                }
                Spacer()
            }
        }.padding().frame(alignment: .center)
    }
}
