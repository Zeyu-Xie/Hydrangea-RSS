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

    @Published var lists: [SourceList]
    @Published var currentList: SourceList?
    @Published var currentSource: String?

    init() {
        self.lists = []
        self.currentList = nil
        self.currentSource = nil
    }

    enum CodingKeys: String, CodingKey {
        case lists
        case currentList
        case currentSource
    }

    // Custom encoding and decoding to handle @Published properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lists = try container.decode([SourceList].self, forKey: .lists)
        self.currentList = try container.decodeIfPresent(SourceList.self, forKey: .currentList)
        self.currentSource = try container.decodeIfPresent(String.self, forKey: .currentSource)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lists, forKey: .lists)
        try container.encodeIfPresent(currentList, forKey: .currentList)
        try container.encodeIfPresent(currentSource, forKey: .currentSource)
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
