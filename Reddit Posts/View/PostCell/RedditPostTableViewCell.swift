//
//  RedditPostTableViewCell.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import UIKit

protocol RedditPostTableViewCellDelegate: class {
    func dismissButtonPressed(post: RedditPost?)
}

class RedditPostTableViewCell: UITableViewCell {
    
    static var identifier: String = "RedditPostTableViewCell"
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursAgoLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    weak var delegate: RedditPostTableViewCellDelegate?
    
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

        unreadView.isHidden = !post.unread
        titleLabel.text = post.title
        hoursAgoLabel.text = "\(post.getHoursAgo()) hours ago"
        
        if let urlString = post.thumbnailUrl, let url = URL(string: urlString) {
            thumbnailImageView.load(url: url)
        } else {
            thumbnailImageView.image = nil
        }
        
        descriptionLabel.text = post.text
        
        if let comments = post.numberComments {
            commentsLabel.text = "\(comments) comments"
        } else {
            commentsLabel.text = ""
        }

        adjustTitleLabelWidth()
    }
    
    @IBAction func dismissButtonPressed() {
        delegate?.dismissButtonPressed(post: post)
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
        thumbnailImageView.isHidden = !loading
        descriptionLabel.isHidden = !loading
        dismissButton.isHidden = !loading
        commentsLabel.isHidden = !loading
    }

}
