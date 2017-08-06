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

//class VTLocation {
//    
//    var photos: [VTPhoto]
//    var coordinate: CLLocationCoordinate2D
//    
//    var images: [UIImage] {
//        return photos.map({ $0.image })
//    }
//    
//    init(location: Location) {
//        
//        coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        
//        photos = []
//
//        guard let locationPhotos = location.photos else { return }
//        
//        for case let photo as Photo in locationPhotos.allObjects {
//            
//            photos.append(VTPhoto(photo: photo))
//            
//        }
//    }
//    
//    init(coord: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
//        photos = []
//        coordinate = coord
//    }
//    
//}

