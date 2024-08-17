import Foundation
import SwiftUI

struct Contents: View {
    
    @State private var rssFeedSources: [String] = []
    @StateObject private var rssFeedViewModel = RSSFeedViewModel()
    
    init() {
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        NavigationView {
            List(rssFeedViewModel.items) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.pubDate)
                        .font(.subheadline)
                    HTMLTextView(html: item.description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("RSS Feed")
            .onAppear {
                rssFeedViewModel.fetchRSSFeed()
            }
        }
    }
}
