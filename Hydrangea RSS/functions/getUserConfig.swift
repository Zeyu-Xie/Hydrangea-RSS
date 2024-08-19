//
//  getUserConfig.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/19.
//

import Foundation

func getUserConfig() -> UserConfig {
    if let savedData = UserDefaults.standard.data(forKey: "userConfig"),
       let userConfig = UserConfig.parseFromData(savedData) {
        return userConfig
    }
    else {
        return UserConfig()
    }
}

