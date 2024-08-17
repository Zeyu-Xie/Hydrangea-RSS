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
                GeometryReader { geometry in
                    URLImage(url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.width / 2.35)
                            .clipped()
                    }
                }.frame(height: UIScreen.main.bounds.width / 2.35)
                
            }
            
            VStack {
                
                NavigationLink(destination: FeedContentView(
                    title: self.title,
                    link: self.link,
                    description: self.description,
                    pubDate: self.pubDate,
                    author: self.author,
                    imageURL: self.imageURL
                )) {
                    Text(title).bold()
                }
                
            }
            
        }.padding().frame(alignment: .center)
    }
    
}
