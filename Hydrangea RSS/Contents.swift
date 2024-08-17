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

struct FeedCardView: View {
    var title: String
    var link: String
    var description: String
    var pubDate: String
    var author: String?
    var imageURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let author = author {
                Text("By \(author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            Text(pubDate)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Link(destination: URL(string: link)!) {
                Text("Read more")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemGray6)))
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .padding(.vertical, 5)
    }
}
