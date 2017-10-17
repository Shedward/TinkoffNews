//
//  NewsArticle+CoreDataCachable.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 17.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

extension NewsArticle: CoreDataCachableModel {
    typealias CachingEntityType = NewsArticleEntity
}

extension NewsArticleEntity: CoreDataCachingEntity {
    typealias OriginalModel = NewsArticle
    
    static var entityName: String {
        return "NewsArticleEntity"
    }
    
    func populate(from model: NewsArticle) {
        self.id = model.id
        self.title = model.title
        self.publicationDate = model.publicationDate
    }
    
    func toModel() -> NewsArticle {
        return NewsArticle(id: id, title: title!, publicationDate: publicationDate!)
    }
}
