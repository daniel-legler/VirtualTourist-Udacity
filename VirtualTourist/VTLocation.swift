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

class VTLocation {
    
    var photos: [VTPhoto]
    var coordinate: CLLocationCoordinate2D
    
    var images: [UIImage] {
        return photos.map({ (vtphoto) -> UIImage in
            return vtphoto.image
        })
    }
    
    init(location: Location) {
        
        coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        photos = []

        guard let locationPhotos = location.photos else { return }
        
        for case let photo as Photo in locationPhotos.allObjects {
            
            photos.append(VTPhoto(photo: photo))
            
        }
    }
    
    init(coord: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        photos = []
        coordinate = coord
    }
    
}


//    var photosAsData: Data {
//
//        var imgs = Data()
//
//        photos.forEach { (img) in  imgs.append(img.data) }
//
//        return imgs
//    }

//    var photoData: NSMutableArray {
//
//        guard photos.count > 0 else {
//            return NSMutableArray()
//        }
//
//        let photosArray = NSMutableArray()
//
//        for photo in photos {
//
//            if let data = UIImagePNGRepresentation(photo) {
//
//                let nsData = NSData(data: data)
//
//                photosArray.add(nsData)
//
//            } else {
//                print("Couldn't convert image to png data")
//            }
//
//        }
//
//        return photosArray
//
//    }

