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
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    
    var post: RedditPost? {
        didSet { configureView() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unreadView.layer.cornerRadius = unreadView.bounds.size.width / 2
        unreadView.layer.masksToBounds = true
    }

    func configureView() {
        guard let post = post else {
            configureLoadingView()
            return
        }
        
        hideViewsForLoading(true)
        
        titleLabel.text = post.title
        hoursAgoLabel.text = "\(post.getHoursAgo()) hours ago"

        adjustTitleLabelWidth()
    }
    
    private func adjustTitleLabelWidth() {
        if let superview = titleLabel.superview {
            let width = unreadView.bounds.size.width + hoursAgoLabel.bounds.size.width + 20
            if titleLabel.frame.size.width > superview.bounds.size.width - width {
                titleLabel.frame.size.width = superview.bounds.size.width - width
            }
        }
    }
    
    private func configureLoadingView()
    {
        hideViewsForLoading(false)
        loadingView.startAnimating()
    }
    
    private func hideViewsForLoading(_ loading: Bool) {
        loadingView.isHidden = loading
        unreadView.isHidden = !loading
        titleLabel.isHidden = !loading
        hoursAgoLabel.isHidden = !loading
    }

}
