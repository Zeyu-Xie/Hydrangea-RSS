import Foundation
import SwiftUI

struct Contents: View {
    
    @State private var rssFeedSources: [String] = []
    @State private var rssList: RSSList = RSSList(source: "https://rsshub.app/caixin/article")
    @State private var list: [RSSItem] = []
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
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: SourceSwitch()) {
                            Text("Switch RSS Source")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Divider().padding(.vertical)
                    
                    if list.isEmpty {
                        Text("Your source \(Text(UserDefaults.standard.string(forKey: "selectedFeedSource") ?? "").foregroundStyle(.link)) does not have any feeds now.")
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                    } else {
                        ForEach(list) { item in
                            NavigationLink(destination: FeedContentView(
                                title: item.title,
                                link: item.link,
                                description: item.description?.string,
                                pubDate: item.pubDate,
                                author: item.generator,
                                imageURL: item.imageURL
                            )) {
                                FeedCardView(
                                    title: item.title,
                                    link: item.link,
                                    description: item.description?.string,
                                    pubDate: item.pubDate,
                                    author: item.generator,
                                    imageURL: item.imageURL
                                )
                            }
                            .buttonStyle(PlainButtonStyle()) // Optional: To remove the default NavigationLink styling
                            .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                rssList.source = UserDefaults.standard.string(forKey: "selectedFeedSource")!
                rssList.load(completion: {
                    list = rssList.list
                })
            }
            .navigationTitle("Contents")
        }
    }
}

