//
//  RedditPostMapper.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import Foundation

class RedditPostMapper {
    
    static func getPostsFromJSON(_ json: [String: Any]) -> [RedditPost] {
        var posts: [RedditPost] = []
        
        guard let data = json["data"] as? [String: Any] else { return posts }
        guard let children = data["children"] as? [[String: Any]] else { return posts }
        
        for child in children {
            posts.append(getPostFromJSON(child))
        }
        
        return posts
    }
    
    static func getPostFromJSON(_ json: [String: Any]) -> RedditPost {
        let post = RedditPost()
        
        guard let data = json["data"] as? [String: Any] else { return post }
        
        post.title = data["title"] as? String
        post.numberComments = data["num_comments"] as? Int
        
        return post
    }
    
}
