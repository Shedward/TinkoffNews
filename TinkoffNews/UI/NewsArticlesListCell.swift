//
//  NewsArticlesListCell.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

class NewsArticlesListCell: UITableViewCell {
    
    @IBOutlet weak var publicationDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private static let publicationDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    func configure(with article: NewsArticle) {
        publicationDateLabel.text = NewsArticlesListCell.publicationDateFormatter.string(from: article.publicationDate)
        titleLabel.text = article.title
    }
}
