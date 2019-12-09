//
//  RedditPostsViewModel.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import Foundation

protocol RedditPostsViewModelDelegate: class {
    func visiblePostsUpdated(posts: [RedditPost], newIndexes: [Int])
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
    private var readPosts: [RedditPost] = []
    
    weak var delegate: RedditPostsViewModelDelegate?
    
    private(set) var visiblePosts: [RedditPost] = []
    private(set) var isFetchingPosts: Bool = false
    
    func fetchMorePosts() {
        if !canFetchMorePosts() {
            return
        }
        
        let after: String? = posts.last?.id
        isFetchingPosts = true
        
        RedditAPIClient.shared.getPosts(after) { (posts, error) in
            self.isFetchingPosts = false
            
            if let error = error {
                self.processError(error)
                return
            }
            
            if let posts = posts {
                self.filterVisiblePosts(posts)
            }
        }
    }
    
    func markPostAsRead(_ post: RedditPost) {
        if !arrayContainsPost(readPosts, post: post) {
            post.unread = false
            readPosts.append(post)
        }
    }
    
    func resetPosts() {
        posts.removeAll()
        visiblePosts.removeAll()
    }
    
    func canFetchMorePosts() -> Bool {
        return posts.count < postsLimit && !isFetchingPosts
    }
    
    private func arrayContainsPost(_ array: [RedditPost], post: RedditPost) -> Bool {
        return array.contains { (currentPost) -> Bool in
            return post.id == currentPost.id
        }
    }
    
    private func filterVisiblePosts(_ newPosts: [RedditPost]) {
        posts.append(contentsOf: newPosts)
        
        var indexes: [Int] = []
        
        for post in newPosts {
            if arrayContainsPost(readPosts, post: post) {
                post.unread = false
            }
            
            if !arrayContainsPost(removedPosts, post: post) {
                visiblePosts.append(post)
                indexes.append(visiblePosts.count - 1)
            }
        }
                
        DispatchQueue.main.async {
            self.delegate?.visiblePostsUpdated(posts: self.visiblePosts, newIndexes: indexes)
        }
    }
    
    private func processError(_ error: Error) {
        delegate?.receivedError(description: error.localizedDescription)
    }
    
    func removeVisiblePost(at position: Int) {
        if position < visiblePosts.count {
            let post = visiblePosts.remove(at: position)
            removedPosts.append(post)
        }
    }
    
}
