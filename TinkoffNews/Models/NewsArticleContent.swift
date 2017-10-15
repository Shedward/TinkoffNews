//
//  NewsArticleContent.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 15.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

struct NewsArticleContent: NewsArticleContentInterface {
    let id: Int32
    let title: String
    let content: String
    
    init(id: Int32, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
