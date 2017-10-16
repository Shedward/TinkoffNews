//
//  NSAttributedString+HTML.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

extension UILabel {
    func setHtmlText(_ htmlText: String) {
        let htmlWithFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlText) as String
        let data = htmlWithFont.data(using: .utf8, allowLossyConversion: true)!
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType:NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            self.attributedText = attributedString
        } else {
            self.attributedText = nil
        }
    }
}
