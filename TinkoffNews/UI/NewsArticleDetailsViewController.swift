//
//  NewsArticleDetailsViewController.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

class NewsArticleDetailsViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    var articleId: Int32? = nil {
        didSet {
            if isViewLoaded {
                reloadArticle()
            }
        }
    }
    
    override func viewDidLoad() {
        reloadArticle()
    }
    
    private func reloadArticle() {
        if let articleId = self.articleId {
            Application.shared.newsRepository.articleDetails(id: articleId) { [weak self] result in
                switch result {
                case .success(let article):
                    self?.title = article.title
                    self?.webView.loadHTMLString(article.content, baseURL: nil)
                case .failure(let error):
                    self?.show(error: error)
                }
            }
        } else {
            webView.loadHTMLString("", baseURL: nil)
        }
    }
}
