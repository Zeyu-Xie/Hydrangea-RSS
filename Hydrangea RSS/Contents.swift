import Foundation
import SwiftUI

struct Contents: View {
    
    @StateObject private var rssList: RSSList = RSSList(source: "")
    
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
                    
                    if rssList.list.isEmpty {
                        
                        // Blank & Loading
                        if rssList.isLoading {
                            LoadingView()
                        }
                        
                        // Blank & Loaded
                        else {
                            Text("Your source \(Text(UserDefaults.standard.string(forKey: "selectedFeedSource") ?? "").foregroundStyle(.link)) does not have any feeds now.")
                                .multilineTextAlignment(.leading)
                                .padding(.vertical)
                        }
                    } else {
                        
                        // Not Blank & Loading
                        if rssList.isLoading {
                            LoadingView()
                        }
                        
                        // Not Blank
                        ForEach(rssList.list) { item in
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
                    
                })
            }
            .navigationTitle("Contents")
        }
    }
}

