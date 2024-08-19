import SwiftUI

struct ContentView: View {
    
    init() {
        initUserConfig()
    }
    
    var body: some View {
        TabView {
            Contents()
                .tabItem {
                    Image(systemName: "square.fill.text.grid.1x2")
                    Text("Contents")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
