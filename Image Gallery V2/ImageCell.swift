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
  
    private func fetchImage() {
        
        if let url = imageURL {
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                let urlContents = try? Data(contentsOf: url.imageURL)
                
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    if let imageData = urlContents {
                        if let image = UIImage(data: imageData) {
                            self?.imageView.image = image
                        } else {
                            let brokenPic = UIImage(named: "work-in-progress", in: Bundle(for: self!.classForCoder), compatibleWith: self!.traitCollection)
                            self?.imageView.image = brokenPic
                        }
                    }
                }
                
            }
        }
    }
}
