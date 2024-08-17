import Foundation
import SwiftUI

struct Contents: View {
    
    @State private var selectedFeedSource: String = "" {
        didSet {
            // 当 selectedFeedSource 改变时重新获取数据
            fetchAndRenderRSSFeed()
        }
    }
    
    @State private var rssFeedSources: [String] = []
    @StateObject private var feedContentView = FeedContentView()
    @State private var showingAlert: Bool = false
    
    init() {
        // Get rssFeedSources - Case nil
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Spacer()
                    NavigationLink(destination: SourceSwitch()) {
                        Text("Switch RSS Source")
                    }
                }.padding(.horizontal)
                
                if (!feedContentView.items.isEmpty) {
                    ForEach(feedContentView.items) { item in
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
                }
                else {
                    Text("Your source: \n\(UserDefaults.standard.string(forKey: "selectedFeedSource") ?? "")\ndoes not have any feeds now.")
                }
            }.onAppear {
                feedContentView.fetchRSSFeed()
                
                // Get rssFeedSources - Case [...]
                if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
                    rssFeedSources = savedArray
                }
            }.navigationTitle("Contents")
        }
    }
    
    private func fetchAndRenderRSSFeed() {
        feedContentView.fetchRSSFeed()
        DispatchQueue.main.async {
            self.feedContentView.items = self.feedContentView.items // 触发视图更新
        }
    }
}
