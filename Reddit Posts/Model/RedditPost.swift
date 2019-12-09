//
//  RedditPost.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import Foundation

class RedditPost {
    
    var id: String!
    var title: String?
    var text: String?
    var author: String?
    var thumbnailUrl: String?
    var numberComments: Int?
    var created: Double?
    var unread: Bool = true
    
    func getHoursAgo() -> Int {
        guard let created = created else {
            return 0
        }
        
        let now = Date().timeIntervalSince1970
        let diff = now - created
        let hours = diff / 3600
        
        return Int(hours)
    }
    
}
