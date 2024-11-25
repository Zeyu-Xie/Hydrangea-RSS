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
    
    @StateObject private var userConfig: UserConfig = getUserConfig()
    
    var body: some View {
        
        NavigationStack {
            List {
                Section(header: Text("Local Sources")) {
                    if let sourceList = userConfig.sourceList {
                        ForEach(sourceList.list, id: \.self) { item in
                            Button(action: {
                                userConfig.rssList = RSSList(source: item)
                                userConfig.rssList?.load(completion: {
                                    uploadUserConfig(userConfig: userConfig)
                                    dismiss()
                                })
                            }) {
                                Text(item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Source Switch")
        }
    }
}
