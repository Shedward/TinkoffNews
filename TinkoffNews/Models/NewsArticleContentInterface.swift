//
//  NewsArticleContent.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 14.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

protocol NewsArticleContentInterface: IdentifiableObject {
    var title: String { get }
    var content: String { get }
}
