//
//  RedditAPIClient.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import Foundation

class RedditAPIClient: BaseAPIClient {
    
    static let shared = RedditAPIClient()
    
    var handleErrors: Bool = true
    var pageSize: Int = 10
    
    internal override init() {
        super.init()
        baseURL = "https://www.reddit.com/r/argentina/top/.json"
    }
    
    func getPosts(_ after: String?, completion: @escaping([RedditPost]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)?limit=\(pageSize)")
        let request = createRequestForURL(url!)

        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if self.handleErrors {
                    self.handleError(response: response, error: error)
                } else {
                    completion(nil, error)
                }
                return
            }
            
            var posts: [RedditPost]? = nil
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                posts = RedditPostMapper.getPostsFromJSON(json)
            }
            
            completion(posts, nil)
        }
        
        task.resume()
    }
    
}
