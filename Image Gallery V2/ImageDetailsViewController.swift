//
//  ImageDetailsViewController.swift
//  ImageGallery
//
//  Created by Jason Wong on 26/3/2020.
//  Copyright © 2020 Papa. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
            didSet {
                if view.window != nil {
                imageView.image = nil
                fetchImage()
                }
            }
        }
      
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1 / 10
        
    }
    
}
