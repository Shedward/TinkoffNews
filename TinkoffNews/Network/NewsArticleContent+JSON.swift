//
//  NewsArticleContent+JSON.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 15.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

extension NewsArticleContent: Decodable {
    
    private enum Keys: String, CodingKey {
        case title
        case content
    }
    
    private enum TitleKeys: String, CodingKey {
        case id
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.content = try container.decode(String.self, forKey: .content)
        
        let titleContainer = try container.nestedContainer(keyedBy: TitleKeys.self, forKey: .title)
        self.id = try titleContainer.decodeStringInt(forKey: .id)
        self.title = try titleContainer.decode(String.self, forKey: .text)
    }
}
