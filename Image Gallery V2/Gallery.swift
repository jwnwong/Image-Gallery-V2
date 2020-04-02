//
//  Gallery.swift
//  ImageGallery
//
//  Created by Jason Wong on 27/3/2020.
//  Copyright © 2020 Papa. All rights reserved.
//

import Foundation

struct Gallery: Codable {

    var galleryName = "Untitled Gallery"
    var imageURLs = [URL]()
    var cellsize: Double = 200
    var count: Int {
        return  imageURLs.count
    }

    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json:Data) {
        if let newValue = try? JSONDecoder().decode(Gallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(galleryName: String, imageURLs: [URL], cellsize: Double) {
        self.galleryName = galleryName
        self.imageURLs = imageURLs
        self.cellsize = cellsize
        
    }
}

