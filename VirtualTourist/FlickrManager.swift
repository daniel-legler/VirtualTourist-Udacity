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
    case image(UIImage)
    case error(FlickrError)
}

// Need to evaluate Flickr API to determine possible error values
enum FlickrError:Error {
    case noImagesForLocation(Error)
    case connectionError(Error)
    case invalidCoordinates(Error)
}

struct FlickrURL {
    
    let farmID: String
    let serverID: String
    let photoID: String
    let secret: String
    let size: String
    
    var url: URL {
        return URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg")!
    }
    
}

class FlickrManager {
    
    private init() {}
    
    static let `default` = FlickrManager()
    
    // FOR TESTING ONLY: Returns 20 of the same image
    func _getPhotos (forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (FlickrResponse)->()) {
        
        for _ in 1...20 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4*drand48(), execute: {
                completion(.image(UIImage(named: "weather") ?? UIImage()))
            })
        }
    }
    
    
    func getPhotos (forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (FlickrResponse)->()) {
        
        let lat = Double(coordinate.latitude)
        let lon = Double(coordinate.longitude)
        
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=99c82a1df1fd9f61e3ce8e8b4205cb12&lat=\(lat)&lon=\(lon)&format=json")!

        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else{
                completion(.error(.connectionError(error!)))
                print(error!.localizedDescription)
                return
            }
            
            print(data!)
            
            var parsedData : [String: Any]!
            do {
                try parsedData = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            } catch {
                print(error.localizedDescription)
            }
            
//            print("\n\n\n\n\n\n urlResponse: \n")
//            print(urlResponse)
//            print("\n\n\n\n\n\n data: \n")
//            print(data)
//            print("\n\n\n\n\n\n response: \n")
//
//            guard let response = data as? [String:Any] else {
//                return
//            }
            
//            print(response)
 
            
            // let flickrURL = FlickrURL(farmID: <#T##String#>, serverID: <#T##String#>, photoID: <#T##String#>, secret: <#T##String#>, size: <#T##String#>)
            
            
            
        }
        task.resume()
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
