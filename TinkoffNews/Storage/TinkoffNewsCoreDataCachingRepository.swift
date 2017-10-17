//
//  TinkoffNewsCoreDataRepository.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 17.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import CoreData

class TinkoffNewsCoreDataCachingRepository: TinkoffNewsRepository {
    
    private let apiClient: TinkoffAPIClient
    private let coreDataManager: CoreDataManager
    
    private let workingQueue = DispatchQueue(label: "TinkoffNewsCoreDataRepository.workingQueue", qos: .background)
    
    init(apiClient: TinkoffAPIClient, coreDataManager: CoreDataManager) {
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
    }
    
    func articles(_ completition: @escaping (Result<[NewsArticle]>) -> Void) {
        workingQueue.async {
            let context = self.coreDataManager.contextForCurrentThread()
            let articlesCache = CoreDataCache<NewsArticle>(context: context)
            
            let cachedArticles: [NewsArticle]
            
            do {
                cachedArticles = try articlesCache.getAll(sortedBy: [NSSortDescriptor(key: "publicationDate", ascending: false)])
            } catch (let error) {
                cachedArticles = []
                NSLog("Warning: Failed to load data from CoreDataCache<NewsArticle>: \(error.localizedDescription)")
            }
            
            if cachedArticles.count > 0 {
                completition(.success(cachedArticles))
                return
            }
            
            self.apiClient.getArticlesList { result in
                if case let .success(articlesList) = result {
                    self.workingQueue.async {
                        let context = self.coreDataManager.contextForCurrentThread()
                        let articlesCache = CoreDataCache<NewsArticle>(context: context)
                        
                        do {
                            try articlesCache.add(contentsOf: articlesList)
                            self.coreDataManager.saveAllChanges()
                        } catch (let error) {
                            NSLog("Warning: Failed to save NewsArticles in cache: \(error.localizedDescription)")
                        }
                    }
                }
                    
                completition(result)
            }
        }
    }
    
    func articleDetails(id: Int32, completiton: @escaping (Result<NewsArticleContent>) -> Void) {
        workingQueue.async {
            let context = self.coreDataManager.contextForCurrentThread()
            let articleContentCache = CoreDataCache<NewsArticleContent>(context: context)
            
            let cachedArticleContent: NewsArticleContent?
            do {
                cachedArticleContent = try articleContentCache.get(by: id)
            } catch (let error) {
                cachedArticleContent = nil
                NSLog("Warning: Failed to load data from CoreDataCache<NewsArticleContent>: \(error.localizedDescription)")
            }
            
            if let cachedArticleContent = cachedArticleContent {
                completiton(.success(cachedArticleContent))
                return
            }
            
            self.apiClient.getArticleContent(articleId: id) { result in
                if case let .success(articleContent) = result {
                    self.workingQueue.async {
                        let context = self.coreDataManager.contextForCurrentThread()
                        let articleContentCache = CoreDataCache<NewsArticleContent>(context: context)
                        
                        do {
                            try articleContentCache.add(element: articleContent)
                            self.coreDataManager.saveAllChanges()
                        } catch (let error) {
                            NSLog("Warning: Failed to save NewsArticleContent in cache: \(error.localizedDescription)")
                        }
                    }
                }
                
                completiton(result)
            }
        }
    }
    
    func clearCache(_ completition: (() -> Void)?) {
        workingQueue.async {
            let context = self.coreDataManager.contextForCurrentThread()
            let articlesCache = CoreDataCache<NewsArticle>(context: context)
            let articleContentCache = CoreDataCache<NewsArticleContent>(context: context)
            
            do {
                try articlesCache.clear()
            } catch (let error) {
                NSLog("Warning: Failed to clear articles cache: \(error.localizedDescription)")
            }
            
            do {
                try articleContentCache.clear()
            } catch (let error) {
                NSLog("Warning: Failed to clear article contents cache: \(error.localizedDescription)")
            }
            
            completition?()
            
            self.coreDataManager.saveAllChanges()
        }
    }
}
