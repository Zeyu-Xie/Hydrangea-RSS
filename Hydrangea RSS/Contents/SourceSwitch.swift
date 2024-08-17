//
//  SourceSwitch.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/17.
//

import Foundation
import SwiftUI

struct SourceSwitch: View {
    
    @State private var rssFeedSources: [String] = []
    @State private var selectedItem: String = ""
    
    init() {
        if UserDefaults.standard.array(forKey: "rssFeedSources") == nil {
            UserDefaults.standard.set([], forKey: "rssFeedSources")
        }
    }
    
    var body: some View {
        
        ScrollView {
            ForEach(rssFeedSources, id: \.self) { item in
                Button(action: {
                    UserDefaults.standard.set(item, forKey: "selectedItem")
                }, label: {
                    Text(item)
                })
            }
        }.onAppear {
            if let savedArray = UserDefaults.standard.array(forKey: "rssFeedSources") as? [String] {
                rssFeedSources = savedArray
            }
        }
        
        
    }
}
