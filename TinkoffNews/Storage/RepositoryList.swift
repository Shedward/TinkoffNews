//
//  RepositoryList.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 13.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

protocol RepositoryList {
    associatedtype Element
    
    func refresh()
    var count: Int { get }
    subscript(at index: Int) -> Element { get }
}
