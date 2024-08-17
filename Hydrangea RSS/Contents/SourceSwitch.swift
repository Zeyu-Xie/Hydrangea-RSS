//
//  SourceSwitch.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/17.
//

import Foundation
import SwiftUI

struct SourceSwitch: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var rssFeedSources: [String] = []
    
    init() {
        // Get rssFeedSources - Case nil
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            List {
                Section(header: Text("Local Sources")) {
                    ForEach(rssFeedSources, id: \.self) { item in
                        Button(action: {
                            UserDefaults.standard.set(item, forKey: "selectedFeedSource")
                            dismiss()
                        }) {
                            Text(item)
                        }
                    }
                }
            }
            .navigationTitle("Source Switch")
        }.onAppear {
            // Get rssFeedSources - Case [...]
            if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
                rssFeedSources = savedArray
            }
        }
        
    }
}
