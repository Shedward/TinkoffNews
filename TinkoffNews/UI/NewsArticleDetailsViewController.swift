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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var articleId: Int32? = nil {
        didSet {
            if isViewLoaded {
                reload()
            }
        }
    }
    
    override func viewDidLoad() {
        reload()
    }
    
    private func reload() {
        if let articleId = self.articleId {
            webView.loadHTMLString("", baseURL: nil)
            loadingIndicator.startAnimating()
            
            guard let newsRepository = Application.shared.newsRepository else {
                loadingIndicator.stopAnimating()
                return
            }
    
            newsRepository.articleDetails(id: articleId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let article):
                        self?.title = article.title
                        self?.webView.loadHTMLString(article.content, baseURL: nil)
                    case .failure(let error):
                        self?.show(error: error)
                    }
                    
                    self?.loadingIndicator.stopAnimating()
                }
            }
        } else {
            webView.loadHTMLString("", baseURL: nil)
        }
    }
}
