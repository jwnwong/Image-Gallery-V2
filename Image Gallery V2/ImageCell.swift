//
//  ImageCell.swift
//  ImageGallery
//
//  Created by Jason Wong on 25/3/2020.
//  Copyright © 2020 Papa. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var imageURL: URL? {
        didSet {
            imageView.image = nil
            fetchImage()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var fetcher: ImageFetcherWithCache?
    
    private func fetchImage() {
        
        if let url = imageURL {
            activityIndicator.startAnimating()
            fetcher = ImageFetcherWithCache(fetch: url) {  [weak self] url, image in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    if image != nil {
                        self?.imageView.image = image
                    } else {
                        let brokenPic = UIImage(named: "work-in-progress", in: Bundle(for: self!.classForCoder), compatibleWith: self?.traitCollection)
                        self?.imageView.image = brokenPic
                    }
                }
                
            }
        }
    }
    
    
}
