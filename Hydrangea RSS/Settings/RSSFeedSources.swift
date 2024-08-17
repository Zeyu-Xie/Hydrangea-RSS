import SwiftUI

struct RSSFeedSources: View {
    @State private var rssFeedSources: [String] = []
    @State private var newItem: String = ""
    @State private var showingAlert = false

    init() {
        // Initialize UserDefaults array if it doesn't exist
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }

    var body: some View {
        VStack {
            List {
                ForEach(rssFeedSources, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: deleteItem) // Enable swipe-to-delete
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
        .onAppear {
            // Load saved data from UserDefaults when the view appears
            if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
                rssFeedSources = savedArray
            }
        }
    }

    // Function to delete an item
    private func deleteItem(at offsets: IndexSet) {
        rssFeedSources.remove(atOffsets: offsets)
        UserDefaults.standard.set(rssFeedSources, forKey: "rssFeedSources")
    }

    // Function to add a new item
    private func addItem() {
        guard !newItem.isEmpty else { return }
        rssFeedSources.append(newItem)
        UserDefaults.standard.set(rssFeedSources, forKey: "rssFeedSources")
        newItem = "" // Clear the input field
    }
}
