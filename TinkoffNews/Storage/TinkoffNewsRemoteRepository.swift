//
//  TinkoffNewsRemoteRepository.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

class TinkoffNewsRemoteRepository: TinkoffNewsRepository {
    
    let apiClient: TinkoffAPIClient
    
    init(apiClient: TinkoffAPIClient) {
        self.apiClient = apiClient
    }
    
    func clearCache() {

    }
    
    func articles(_ completition: @escaping (Result<[NewsArticle]>) -> Void) {
        apiClient.getArticlesList(completition)
    }
    
    func articleDetails(id: Int32, completiton: @escaping (Result<NewsArticleContent>) -> Void) {
        apiClient.getArticleContent(articleId: id, completiton)
    }
}
