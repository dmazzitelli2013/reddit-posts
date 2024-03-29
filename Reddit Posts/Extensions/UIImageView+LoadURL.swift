//
//  UIImageView+LoadURL.swift
//  Reddit Posts
//
//  Created by David Mazzitelli on 12/9/19.
//  Copyright © 2019 David Mazzitelli. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.isHidden = false
                    }
                } else {
                    self?.loadEmpty()
                }
            } else {
                self?.loadEmpty()
            }
        }
    }
    
    private func loadEmpty() {
        DispatchQueue.main.async {
            self.image = nil
            self.isHidden = true
        }
    }
    
}
