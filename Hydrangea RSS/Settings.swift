import SwiftUI

struct Settings: View {
        
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("General")) {
                    NavigationLink(destination: Text("General Information")) {
                        Text("Profile Settings")
                    }
                    NavigationLink(destination: Text("Notification Preferences")) {
                        Text("Notifications")
                    }
                    NavigationLink(destination: Text("Appearance Settings")) {
                        Text("Appearance")
                    }
                    NavigationLink(destination: Text("Language Selection")) {
                        Text("Language")
                    }
                }
                
                Section(header: Text("Feed")) {
                    NavigationLink(destination: RSSFeedSources()) {
                        Text("RSS Feed Sources")
                    }
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Privacy Settings")) {
                        Text("Privacy")
                    }
                    NavigationLink(destination: Text("Security Settings")) {
                        Text("Security")
                    }
                    NavigationLink(destination: Text("Account Management")) {
                        Text("Account")
                    }
                    NavigationLink(destination: Text("Billing Information")) {
                        Text("Billing")
                    }
                }
                
                Section(header: Text("Support")) {
                    NavigationLink(destination: Text("Help Center")) {
                        Text("Help")
                    }
                    NavigationLink(destination: Text("Contact Us")) {
                        Text("Contact Us")
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: Text("App Version and Info")) {
                        Text("About")
                    }
                    NavigationLink(destination: Text("Terms of Service")) {
                        Text("Terms of Service")
                    }
                    NavigationLink(destination: Text("Privacy Policy")) {
                        Text("Privacy Policy")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
