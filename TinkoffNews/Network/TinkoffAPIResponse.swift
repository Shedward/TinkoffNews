//
//  TinkoffAPIResponse.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 15.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

enum TinkoffAPIResult<T: Decodable> {
    case ok(T)
    case error(String)
}

struct TinkoffAPIResponse<T: Decodable>: Decodable {
    let result: TinkoffAPIResult<T>
    
    private enum Keys: String, CodingKey {
        case resultCode
        case errorMessage
        case payload
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let result: TinkoffAPIResult<T>
        
        let resultStatus = try container.decode(String.self, forKey: .resultCode)
        switch resultStatus {
        case "OK":
            let payload = try container.decode(T.self, forKey: .payload)
            result = .ok(payload)
        default:
            let errorMessage = try container.decode(String.self, forKey: .errorMessage)
            result = .error(errorMessage)
        }
        
        self.result = result
    }
}
