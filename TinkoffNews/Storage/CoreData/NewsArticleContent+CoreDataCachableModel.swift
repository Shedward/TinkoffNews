//
//  NewsArticleContent.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 17.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

extension NewsArticleContent: CoreDataCachableModel {
    typealias CachingEntityType = NewsArticleContentEntity
}

extension NewsArticleContentEntity: CoreDataCachingEntity {
    typealias OriginalModel = NewsArticleContent
    
    static var entityName: String {
        return "NewsArticleContentEntity"
    }
    
    func populate(from model: NewsArticleContent) {
        self.id = model.id
        self.title = model.title
        self.content = model.content
    }
    
    func toModel() -> NewsArticleContent {
        return NewsArticleContent(id: id, title: title!, content: content!)
    }
}
