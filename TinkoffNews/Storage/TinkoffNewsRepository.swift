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
    
    func countOfArticles() -> Int
    func article(at index: Int)
    
    func articleDetails(id: Int)
}
