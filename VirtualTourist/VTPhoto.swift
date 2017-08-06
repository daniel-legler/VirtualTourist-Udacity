//
//  VTPhoto.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/22/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

extension Photo {
    func image() -> UIImage {
        return UIImage(data: (self.data ?? NSData()) as Data) ?? UIImage()
    }
}

//class VTPhoto {
//    
//    var id: String
//    var image: UIImage
//    
//    var data: Data {
//        return image.data
//    }
//    
//    // Initializer for loading a Photo object from CoreData
//    init(photo: Photo) {
//        self.id = photo.id ?? String()
//        self.image = UIImage(data: (photo.data ?? NSData()) as Data) ?? UIImage()
//    }
//    
//    // Initializer for creating a new Photo object in CoreData
//    init(image: UIImage) {
//        id = UUID().uuidString
//        self.image = image
//    }
//}
