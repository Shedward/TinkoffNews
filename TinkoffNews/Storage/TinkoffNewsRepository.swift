//
//  TinkoffNewsRepository.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 13.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

protocol TinkoffNewsRepository {
    func refresh()
    
    func articles(_ completition: (Result<[NewsArticle]>) -> Void)
    func articleDetails(id: Int, completiton: (Result<NewsArticleContent>) -> Void)
}
