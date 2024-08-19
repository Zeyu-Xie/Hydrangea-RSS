//
//  initUserConfig.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/19.
//

import Foundation

func initUserConfig() {
    UserDefaults.standard.set(getUserConfig().toData(), forKey: "userConfig")
}
