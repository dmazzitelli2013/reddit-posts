//
//  RedditPostTableViewCell.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import UIKit

class RedditPostTableViewCell: UITableViewCell {
    
    static var identifier: String = "RedditPostTableViewCell"
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var post: RedditPost? {
        didSet { configureView() }
    }

    func configureView() {
        guard let post = post else {
            configureLoadingView()
            return
        }
        
        loadingView.isHidden = true
        titleLabel.isHidden = false
        // TODO
        
        titleLabel.text = post.title
        // TODO
    }
    
    private func configureLoadingView()
    {
        loadingView.isHidden = false
        titleLabel.isHidden = true
        // TODO
        
        loadingView.startAnimating()
    }

}
