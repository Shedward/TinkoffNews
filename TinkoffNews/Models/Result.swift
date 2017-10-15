//
//  Result.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
