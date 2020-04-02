//
//  Document.swift
//  Image Gallery V2
//
//  Created by Jason Wong on 2/4/2020.
//  Copyright © 2020 Jason Wong. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    var gallery: Gallery?
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        print("typeName is \(typeName)")
        return gallery?.json ??  Data()
         
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data {
            gallery = Gallery(json: json)
        }
    }
}

