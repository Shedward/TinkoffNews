//
//  TinkoffAPIClient.swift
//  TinkoffNews
//
//  Created by Vladislav Maltsev on 14.10.17.
//  Copyright © 2017 Shedward. All rights reserved.
//

import Foundation

class TinkoffAPIClient {
    struct TinkoffAPIClientError: LocalizedError {
        let errorDescription: String?
        
        init(_ description: String) {
            self.errorDescription = description
        }
    }
    
    let endpoint: URL
    
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    @discardableResult
    func getArticlesList(_ completition: @escaping (Result<[NewsArticle]>) -> Void) -> URLSessionTask {
        return get(path: "/news",
                   completition: completition)
    }
    
    @discardableResult
    func getArticleContent(articleId: Int32, _ completition: @escaping (Result<NewsArticleContent>) -> Void) -> URLSessionTask {
        return get(path: "/news_content",
                   parameters: ["id": String(articleId)],
                   completition: completition)
    }
    
    private func get<T: Decodable>(path: String, parameters: [String: String] = [:], completition: @escaping (Result<T>) -> Void) -> URLSessionTask {
        
        guard let url = url(path: path, query: parameters) else {
            fatalError("Failed to format URL for request to endpoint \(endpoint) with path \(path) and parameters \(parameters)")
        }
        
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completition(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(TinkoffAPIResponse<T>.self, from: data)
                    
                    switch response.result {
                    case .ok(let payload):
                        completition(.success(payload))
                    case .error(let errorMessage):
                        completition(.failure(TinkoffAPIClientError(errorMessage)))
                    }

                } catch (let error) {
                    completition(.failure(TinkoffAPIClientError("Parsing error: \(error.localizedDescription)")))
                }
                
            } else {
                completition(.failure(TinkoffAPIClientError("No response")))
            }
        }
        
        task.resume()
        return task
    }
    
    private func url(path: String, query: [String: String]) -> URL? {
        let baseURL = endpoint.appendingPathComponent(path)
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    }
}
