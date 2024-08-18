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
                                .padding()
                        }
                        .background(Color.clear)
                        .cornerRadius(8)
                    }
                    
                    Divider().padding(.vertical)
                    
                    if rssList.list.isEmpty {
                        
                        // Blank & Loading
                        if rssList.isLoading {
                            LoadingView()
                        }
                        
                        // Blank & Loaded
                        else {
                            Text("Your source \(Text(UserDefaults.standard.string(forKey: "selectedFeedSource") ?? "").foregroundColor(.blue)) does not have any feeds now.")
                                .multilineTextAlignment(.leading)
                                .padding(.vertical)
                                .foregroundColor(.gray)
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
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle()) // 保持扁平化按钮样式
                            .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                rssList.source = UserDefaults.standard.string(forKey: "selectedFeedSource")!
                rssList.load(completion: {
                    print(rssList.toString())
                })
            }
            .navigationTitle("Contents")
        }
    }
}
