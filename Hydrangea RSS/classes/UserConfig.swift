//
//  UserConfig.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/19.
//

import Foundation
import Combine

class UserConfig: ObservableObject, Identifiable, Codable {
    let id = UUID()
    
    @Published var sourceList: SourceList?
    @Published var rssList: RSSList?
    
    init() {
        self.sourceList = nil
        self.rssList = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceList
        case rssList
    }
    
    // Custom encoding and decoding to handle @Published properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceList = try container.decodeIfPresent(SourceList.self, forKey: .sourceList)
        self.rssList = try container.decodeIfPresent(RSSList.self, forKey: .rssList)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sourceList, forKey: .sourceList)
        try container.encodeIfPresent(rssList, forKey: .rssList)
    }
}

extension UserConfig {
    
    // Converts UserConfig to Data
    func toData() -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            print("Failed to encode UserConfig: \(error)")
            return nil
        }
    }
    
    // Creates a UserConfig from Data
    static func parseFromData(_ data: Data) -> UserConfig? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(UserConfig.self, from: data)
        } catch {
            print("Failed to decode UserConfig: \(error)")
            return nil
        }
    }
}
