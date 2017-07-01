//
//  Location.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit

class Location {
    
    var photos : [UIImage]
    var coordinate: CLLocationCoordinate2D
    
    init() {
        photos = [UIImage]()
        coordinate = CLLocationCoordinate2D()
    }
}
