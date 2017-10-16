//
//  ParsingHelpers.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 15.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    private enum PublicationDateKeys: String, CodingKey {
        case milliseconds
    }
    
    func decodeTimestamp(forKey key: Key) throws -> Date {
        let dateContainer = try self.nestedContainer(keyedBy: PublicationDateKeys.self, forKey: key)
        let timestamp = try dateContainer.decode(TimeInterval.self, forKey: .milliseconds)
        return Date(timeIntervalSince1970: timestamp / 1000.0)
    }
    
    func decodeStringInt(forKey key: Key) throws -> Int32 {
        let string = try self.decode(String.self, forKey: key)
        guard let int = Int32(string) else {
            let context = DecodingError.Context(codingPath: self.codingPath + [key],
                                                debugDescription: "String does not contains valid integer value")
            throw DecodingError.typeMismatch(Int32.self, context)
        }
        
        return int
    }
}
