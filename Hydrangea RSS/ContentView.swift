import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Contents")
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
