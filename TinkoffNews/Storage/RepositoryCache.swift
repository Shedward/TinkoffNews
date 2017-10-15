//
//  RepositoryCache.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 14.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

protocol RepositoryCache {
    associatedtype Element: IdentifiableObject
    
    func add(element: Element)
    func get(by id: Int32) -> Element?
    func getAll() -> [Element]
    func clear()
}
