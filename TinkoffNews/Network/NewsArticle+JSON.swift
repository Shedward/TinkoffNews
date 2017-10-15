//
//  NewsArticle+JSON.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 15.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

extension NewsArticle: Decodable {
    
    private enum Keys: String, CodingKey {
        case id
        case text
        case publicationDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.id = try container.decode(Int32.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .text)
        self.publicationDate = try container.decodeTimestamp(forKey: .publicationDate)
    }
}
