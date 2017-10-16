//
//  CoreDataCache.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

class CoreDataCache<T: IdentifiableObject>: RepositoryCache {
    
    typealias Element = T

    func add(element: T) {
        fatalError("Not implemented")
    }
    
    func get(by id: Int32) -> T? {
        fatalError("Not implemented")
    }
    
    func getAll() -> [T] {
        fatalError("Not implemented")
    }
    
    func clear() {
        fatalError("Not implemented")
    }
}
