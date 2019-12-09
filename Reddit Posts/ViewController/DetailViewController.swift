//
//  DetailViewController.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/8/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var post: RedditPost? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        guard let post = post else { return }
        
        if let titleLabel = self.titleLabel {
            titleLabel.text = post.title
        }
                
        if let imageView = imageView {
            if let urlString = post.thumbnailUrl, let url = URL(string: urlString) {
                imageView.load(url: url)
            } else {
                imageView.image = nil
            }
        }
        
        if let descriptionLabel = descriptionLabel {
            descriptionLabel.text = post.text
        }
    }

}

