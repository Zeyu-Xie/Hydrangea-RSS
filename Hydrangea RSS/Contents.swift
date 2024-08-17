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
    @StateObject private var feedListView = FeedListView()
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
                
                Divider().padding()
                
                if (!feedListView.items.isEmpty) {
                    ForEach(feedListView.items) { item in
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
                    HStack {
                        Text("Your source \(Text(UserDefaults.standard.string(forKey: "selectedFeedSource") ?? "").foregroundStyle(.link))\ndoes not have any feeds now.").multilineTextAlignment(.leading)
                        Spacer()
                    }.padding(.horizontal)
                    
                }
            }.onAppear {
                feedListView.fetchRSSFeed()
                
                // Get rssFeedSources - Case [...]
                if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
                    rssFeedSources = savedArray
                }
            }.navigationTitle("Contents")
        }
    }
    
    private func fetchAndRenderRSSFeed() {
        feedListView.fetchRSSFeed()
        DispatchQueue.main.async {
            self.feedListView.items = self.feedListView.items // 触发视图更新
        }
    }
}
