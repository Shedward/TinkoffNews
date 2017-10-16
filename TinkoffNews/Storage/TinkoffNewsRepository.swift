//
//  TinkoffNewsRepository.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 13.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

protocol TinkoffNewsRepository {
    func clearCache()
    
    func articles(_ completition: @escaping (Result<[NewsArticle]>) -> Void)
    func articleDetails(id: Int32, completiton: @escaping (Result<NewsArticleContent>) -> Void)
}
