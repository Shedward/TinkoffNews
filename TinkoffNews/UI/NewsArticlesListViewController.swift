//
//  ArticlesListViewController.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 16.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import UIKit

enum NewsArticlesListViewControllerSegue: Segue {
    case showArticleDetails(NewsArticle)
    
    var segueIdentifier: String {
        switch self {
        case .showArticleDetails: return "ShowArticleDetails"
        }
    }
}

class NewsArticlesListViewController: UITableViewController, ArticlesListDataSourceDelegate {
    
    var articlesDataSource: ArticlesListDataSource!
    
    override func viewDidLoad() {
        configurePullToRefresh()
        
        self.articlesDataSource = ArticlesListDataSource(delegate: self)
        tableView.dataSource = articlesDataSource
        tableView.delegate = self
        
        showRefreshing()
        articlesDataSource.reload()
        
        NotificationCenter.default.addObserver(self, selector: #selector(repositoriesDidFinishInitialization), name: ApplicationNotification.repositoriesAreReady.name, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didPullToRefresh() {
        articlesDataSource.reload(droppingCache: true)
    }
    
    @objc private func repositoriesDidFinishInitialization() {
        articlesDataSource.reload()
    }
    
    private func configurePullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    private func showRefreshing() {
        guard let refreshControl = self.refreshControl else {
            return
        }
        
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
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
    
    // Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articlesDataSource.article(at: indexPath)
        performSegue(NewsArticlesListViewControllerSegue.showArticleDetails(article))
    }
    
    override func prepare(for storyboardSegue: UIStoryboardSegue, sender: Any?) {
        guard let segue = sender as? NewsArticlesListViewControllerSegue else {
            return
        }
        
        switch segue {
        case .showArticleDetails(let article):
            let destinationViewController = storyboardSegue.destination as! NewsArticleDetailsViewController
            destinationViewController.articleId = article.id
            destinationViewController.title = article.title
        }
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
        guard let newsRepository = Application.shared.newsRepository else {
            self.delegate?.dataSourceDidUpdateArticles(self)
            return
        }

        newsRepository.articles { [weak self] result in
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
    
    func article(at indexPath: IndexPath) -> NewsArticle {
        return articles[indexPath.item]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsArticlesListCell.self)) as! NewsArticlesListCell
        
        let article = self.article(at: indexPath)
        articleCell.configure(with: article)
        return articleCell
    }
}
