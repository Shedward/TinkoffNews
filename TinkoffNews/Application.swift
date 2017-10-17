//
//  Application.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

class Application {
    static let shared: Application = Application()
    
    var newsRepository: TinkoffNewsRepository?
    
    private var coreDataManager: CoreDataManager?
    
    private init() {
        let serverURL = URL(string: "https://api.tinkoff.ru/v1")!
        let apiClient = TinkoffAPIClient(endpoint:serverURL)
        
        DispatchQueue.global(qos: .background).async {
            let coreDataManager = CoreDataManager(modelName: "TinkoffNews")
            self.coreDataManager = coreDataManager
            self.newsRepository = TinkoffNewsCoreDataCachingRepository(apiClient: apiClient, coreDataManager: coreDataManager)
        }
    }
    
    func saveAllChanges() {
        coreDataManager?.saveAllChanges()
    }
}
