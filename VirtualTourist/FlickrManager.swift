//
//  FlickrManager.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import Foundation
import MapKit

typealias FM = FlickrManager

enum FlickrResponse {
    case images([UIImage])
    case error(FlickrError)
}

enum FlickrError {
    case noImagesForLocation(Error)
    case connectionError(Error)
}

class FlickrManager {
    
    private init() {}
    
    static let `default` = FlickrManager()
    
    func getPhotos (forCoordinate: CLLocationCoordinate2D, completion: (FlickrResponse)->()) {
        
    }
    
    
}
