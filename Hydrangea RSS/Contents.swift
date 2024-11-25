import Foundation
import SwiftUI

struct Contents: View {
    
    @StateObject private var userConfig: UserConfig = getUserConfig()
    
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
                    
                    if let rssList = userConfig.rssList {
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
                                NavigationLink(destination: FeedContentView(rssItem: item)) {
                                    FeedCardView(rssItem: item)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle()) // 保持扁平化按钮样式
                                .padding(.vertical)
                            }
                        }
                    } else {
                        Text("You have not chosen a source yet.")
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                            .foregroundColor(.gray)
                    }
                    
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("Contents")
            .onAppear() {
                userConfig.rssList?.load(completion: {
                    
                })
            }
        }
    }
}
