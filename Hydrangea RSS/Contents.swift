import Foundation
import SwiftUI

struct Contents: View {
    
    @State private var selectedFeedSource: String = "" {
        didSet {
            fetchAndRenderRSSFeed() // Refresh data when the selected source changes
        }
    }
    
    @State private var rssFeedSources: [String] = []
    @StateObject private var feedListView = FeedListView()
    @State private var showingAlert: Bool = false
    
    init() {
        // Initialize rssFeedSources in UserDefaults if nil
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    headerView
                    
                    Divider().padding(.vertical)
                    
                    if feedListView.items.isEmpty {
                        emptyFeedView
                    } else {
                        feedListViewContent
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                fetchInitialData()
            }
            .navigationTitle("Contents")
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            NavigationLink(destination: SourceSwitch()) {
                Text("Switch RSS Source")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var emptyFeedView: some View {
        Text("Your source \(Text(UserDefaults.standard.string(forKey: "selectedFeedSource") ?? "").foregroundStyle(.link)) does not have any feeds now.")
            .multilineTextAlignment(.leading)
            .padding(.vertical)
    }
    
    private var feedListViewContent: some View {
        ForEach(feedListView.items) { item in
            NavigationLink(destination: FeedContentView(
                title: item.title,
                link: item.link,
                description: item.description.string,
                pubDate: item.pubDate,
                author: item.generator,
                imageURL: item.imageURL
            )) {
                FeedCardView(
                    title: item.title,
                    link: item.link,
                    description: item.description.string,
                    pubDate: item.pubDate,
                    author: item.generator,
                    imageURL: item.imageURL
                )
            }
            .buttonStyle(PlainButtonStyle()) // Optional: To remove the default NavigationLink styling
            .padding(.vertical)
        }
    }
    
    private func fetchAndRenderRSSFeed() {
        feedListView.fetchRSSFeed()
        DispatchQueue.main.async {
            self.feedListView.items = self.feedListView.items // Trigger view update
        }
    }
    
    private func fetchInitialData() {
        feedListView.fetchRSSFeed()
        
        if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
            rssFeedSources = savedArray
        }
    }
}

