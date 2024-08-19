//
//  uploadUserConfig.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/20.
//

import Foundation

func uploadUserConfig(userConfig: UserConfig) {
    let userConfigData = userConfig.toData()
    UserDefaults.standard.set(userConfigData, forKey: "userConfig")
}
