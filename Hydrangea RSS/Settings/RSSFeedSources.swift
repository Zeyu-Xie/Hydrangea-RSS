import SwiftUI

struct RSSFeedSources: View {
    
    @State private var newItem: String = ""
    @State private var showingAlert = false
    
    @StateObject private var userConfig: UserConfig = getUserConfig()
    
    init() {
        // Initialize UserDefaults array if it doesn't exist
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        VStack {
            List {
                if let sourceList = userConfig.sourceList {
                    ForEach(sourceList.list, id: \.self) { item in
                        Text(item)
                    }.onDelete(perform: deleteItem) // Enable swipe-to-delete
                }
                
            }
            
            Button(action: {
                showingAlert = true
            }) {
                Text("Add Item")
            }
            .alert("Add New Item", isPresented: $showingAlert, actions: {
                TextField("Enter new item", text: $newItem)
                Button("Add", action: addItem)
                Button("Cancel", role: .cancel, action: {})
            })
        }
    }
    
    // Function to delete an item
    private func deleteItem(at offsets: IndexSet) {
        userConfig.sourceList?.list.remove(atOffsets: offsets)
        uploadUserConfig(userConfig: userConfig)
    }
    
    
    // Function to add a new item
    private func addItem() {
        guard !newItem.isEmpty else { return }
        if userConfig.sourceList == nil {
            userConfig.sourceList = SourceList(name: "", list: [newItem])
        }
        else {
            userConfig.sourceList!.list.append(newItem)
        }
        newItem = "" // Clear the input field
        uploadUserConfig(userConfig: userConfig)
    }
}
