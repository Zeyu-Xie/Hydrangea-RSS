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
                FeedLabelView(labelText: item.title, labelGenerator: item.generator)
            }
            .navigationTitle("RSS Feed")
            .onAppear {
                rssFeedViewModel.fetchRSSFeed()
            }
        }
    }
}
