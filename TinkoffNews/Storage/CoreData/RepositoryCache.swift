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
    
    func add(element: Element) throws
    func get(by id: Int32) throws -> Element?
    func getAll(sortedBy: [NSSortDescriptor]) throws -> [Element]
    func clear() throws
    
    func beginUpdates()
    func endUpdates() throws
}
