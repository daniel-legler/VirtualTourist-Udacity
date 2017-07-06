//
//  Location.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit

class VTLocation {
    
    var photos : [UIImage]
    var coordinate: CLLocationCoordinate2D
    
    init() {
        photos = [UIImage]()
        coordinate = CLLocationCoordinate2D()
    }
    
    var photoData: NSMutableArray {
        
        if photos.count == 0 {
            return NSMutableArray()
        }
        
        let photosArray = NSMutableArray()
        
        for photo in photos {
            
            if let data = UIImagePNGRepresentation(photo) {
                
                let nsData = NSData(data: data)
                
                photosArray.add(nsData)
                
            } else {
                print("Couldn't convert image to png data")
            }
            
        }

        return photosArray
        
    }
}
