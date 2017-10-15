//
//  NewsArticle.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 15.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

struct NewsArticle: NewsArticleInterface {
    let id: Int32
    let title: String
    let publicationDate: Date
    
    init(id: Int32, title: String, publicationDate: Date) {
        self.id = id
        self.title = title
        self.publicationDate = publicationDate
    }
}
