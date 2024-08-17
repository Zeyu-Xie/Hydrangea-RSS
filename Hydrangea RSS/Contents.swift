import Foundation
import SwiftUI

struct Contents: View {
    
    @State private var selectedFeedSource: String = ""
    
    @State private var rssFeedSources: [String] = []
    @StateObject private var rssFeedViewModel = RSSFeedViewModel()
    @State private var showingAlert: Bool = false
    
    init() {
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationLink(destination: SourceSwitch()) {
                    Text("Switch RSS Source")
                }
                ForEach(rssFeedViewModel.items) { item in
                    FeedLabelView(
                        title: item.title,
                        link: item.link,
                        description: item.description.string,
                        pubDate: item.pubDate,
                        author: item.generator,
                        imageURL: item.imageURL
                    )
                    Divider()
                }
            }.onAppear {
                rssFeedViewModel.fetchRSSFeed()
            }.navigationTitle("Contents")
        }
    }
    
}
