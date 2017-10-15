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
        return Date(timeIntervalSince1970: timestamp)
    }
}
