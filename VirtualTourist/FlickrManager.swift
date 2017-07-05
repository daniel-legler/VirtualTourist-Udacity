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

// Need to evaluate Flickr API to determine possible error values
enum FlickrError {
    case noImagesForLocation(Error)
    case connectionError(Error)
    case invalidCoordinates(Error)
}

class FlickrManager {
    
    private init() {}
    
    static let `default` = FlickrManager()
    
    func getPhotos (forCoordinate coordinate: CLLocationCoordinate2D, completion: (FlickrResponse)->()) {
        
        let lat = Double(coordinate.latitude)
        let lon = Double(coordinate.longitude)
        
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=40f3e76af5048bfe2cc40080eb87ac7a&lat=\(lat)&lon=\(lon)&format=json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else{
                print(error?.localizedDescription)
                return
            }
            
            print(urlResponse)
            
            print(data)
        }
    }
    
    func handleError (error: FlickrError) -> String {
        return "There was an error downloading images"
        
//        switch error {
//            case .connectionError(let error):
//                return "Connection Error"
//            case .noImagesForLocation(let error):
//                return "No images found near that location"
//        }
        
    }
    
    
    
    
}
