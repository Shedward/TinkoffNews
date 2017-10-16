//
//  ArticlesListViewController.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

class NewsArticlesListViewController: UITableViewController, ArticlesListDataSourceDelegate {
    
    var articlesDataSource: ArticlesListDataSource!
    
    override func viewDidLoad() {
        configurePullToRefresh()
        
        self.articlesDataSource = ArticlesListDataSource(delegate: self)
        tableView.dataSource = articlesDataSource
        articlesDataSource.reload()
    }
    
    @objc private func didPullToRefresh() {
        articlesDataSource.reload(droppingCache: true)
    }
    
    private func configurePullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // ArticlesListDataSourceDelegate
    
    func dataSourceDidUpdateArticles(_ dataSource: ArticlesListDataSource) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func dataSource(_ dataSource: ArticlesListDataSource, didFailedWithError error: Error) {
        show(error: error)
        refreshControl?.endRefreshing()
    }
}

protocol ArticlesListDataSourceDelegate: class {
    func dataSourceDidUpdateArticles(_ dataSource: ArticlesListDataSource)
    func dataSource(_ dataSource: ArticlesListDataSource, didFailedWithError error: Error)
}

class ArticlesListDataSource: NSObject, UITableViewDataSource {
    
    private var articles: [NewsArticle] = []
    
    weak var delegate: ArticlesListDataSourceDelegate?
    
    init(delegate: ArticlesListDataSourceDelegate) {
        self.delegate = delegate
    }
    
    func reload(droppingCache: Bool = false) {
        Application.shared.newsRepository.articles { [weak self] result in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                
                switch result {
                case .success(let articles):
                    self.articles = articles
                    self.delegate?.dataSourceDidUpdateArticles(self)
                case .failure(let error):
                    self.articles = []
                    self.delegate?.dataSource(self, didFailedWithError: error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsArticlesListCell.self)) as! NewsArticlesListCell
        
        let article = articles[indexPath.item]
        articleCell.configure(with: article)
        return articleCell
    }
}
