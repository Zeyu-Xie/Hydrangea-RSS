import Foundation
import SwiftUI

struct Contents: View {
    
    @State private var rssFeedSources: [String] = []

    init() {
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        List {
            ForEach(rssFeedSources, id: \.self) { item in
                Text(item)
            }
        }.onAppear {
            if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
                rssFeedSources = savedArray
            }
        }
    }
}
