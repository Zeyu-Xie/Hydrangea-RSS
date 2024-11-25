//
//  SourceList.swift
//  Hydrangea RSS
//
//  Created by Zeyu Xie on 2024/8/19.
//

import Foundation
import Combine

class SourceList: ObservableObject, Identifiable, Codable {
    let id = UUID()

    @Published var name: String?
    @Published var list: [String]

    init(name: String? = nil, list: [String]?) {
        self.name = name
        self.list = list ?? []
    }

    enum CodingKeys: String, CodingKey {
        case name
        case list
    }

    // Custom decoding to handle @Published properties
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.list = try container.decode([String].self, forKey: .list)
    }

    // Custom encoding to handle @Published properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(list, forKey: .list)
    }
}

