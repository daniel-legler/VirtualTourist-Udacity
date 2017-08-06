//
//  Location.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit

extension UIImage {
    var data: Data {
        return UIImagePNGRepresentation(self) ?? Data()
    }
    
    static func ==(lhs: UIImage, rhs: UIImage) -> Bool {
        if let lhsData = UIImagePNGRepresentation(lhs), let rhsData = UIImagePNGRepresentation(rhs) {
            return lhsData == rhsData
        }
        return false
    }
}

extension Location {
    
    func coordinate() -> CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
    }
    
    func images() -> [UIImage] {
        
        guard self.photos != nil else { return [] }
        
        var images = [UIImage]()
        
        for case let photo as Photo in self.photos! {
            
            images.append(photo.image())
            
        }
        
        return images
    }
}

