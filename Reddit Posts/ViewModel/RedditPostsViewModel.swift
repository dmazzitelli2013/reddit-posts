//
//  RedditPostsViewModel.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import Foundation

protocol RedditPostsViewModelDelegate: class {
    func visiblePostsUpdated(posts: [RedditPost])
    func receivedError(description: String)
}

extension RedditPostsViewModelDelegate {
    func visiblePostsUpdated(posts: [RedditPost]) {}
    func receivedError(description: String) {}
}

class RedditPostsViewModel {
    
    private var postsLimit: Int = 50
    private var posts: [RedditPost] = []
    private var removedPosts: [RedditPost] = []
    
    weak var delegate: RedditPostsViewModelDelegate?
    
    private(set) var visiblePosts: [RedditPost] = []
    
    func fetchMorePosts() {
        if posts.count >= postsLimit {
            return
        }
        
        RedditAPIClient.shared.getPosts(nil) { (posts, error) in
            if let error = error {
                self.processError(error)
                return
            }
            
            if let posts = posts {
                self.filterVisiblePosts(posts)
                
                DispatchQueue.main.async {
                    self.delegate?.visiblePostsUpdated(posts: self.visiblePosts)
                }
            }
        }
    }
    
    private func filterVisiblePosts(_ posts: [RedditPost]) {
        self.posts = posts
        
        // TODO: filter
        visiblePosts = posts
    }
    
    private func processError(_ error: Error) {
        // TODO
    }
    
    func removeVisiblePost(at position: Int) {
        if position < visiblePosts.count {
            let post = visiblePosts.remove(at: position)
            removedPosts.append(post)
        }
    }
    
}
