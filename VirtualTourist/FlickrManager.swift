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
    case noImageAtUrl(Error)
    case connectionError(Error)
    case invalidCoordinates(Error)
}

struct FlickrPhotoURL {
    
    let farmID: String
    let serverID: String
    let photoID: String
    let secret: String
    
    var url: URL {
        return URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret)_n.jpg")!
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
        
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=99c82a1df1fd9f61e3ce8e8b4205cb12&lat=\(lat)&lon=\(lon)&per_page=20&format=json&nojsoncallback=1")!

        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else{
                print(error!.localizedDescription)
                completion(.error(.connectionError(error!)))
                return
            }
            
            var parsedData : [String: Any]!
            do {
                try parsedData = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            } catch {
                print(error.localizedDescription)
            }
            
//            print(parsedData)
            
            guard let photosObj = parsedData["photos"] as? [String:Any] else { print("Couldn't get photos"); return }
            guard let photos = photosObj["photo"] as? [[String:Any]] else { return }
            
            for photo in photos {
                
                let fID = photo["farm"]!
                guard let serverID = photo["server"]! as? String else { print("server"); return }
                guard let photoID = photo["id"]! as? String else { print("id"); return }
                guard let secret = photo["secret"]! as? String else { print("secret"); return }
                
                let flickrURL = FlickrPhotoURL(farmID: String(describing: fID) , serverID: serverID, photoID: photoID, secret: secret)

                let photoTask = URLSession.shared.dataTask(with: flickrURL.url, completionHandler: { (data, urlResponse, error) in
                    
                    guard let data = data else { return }
                    
                    let image = UIImage(data: data)
                    
                    let flickrResponse = image != nil ? FlickrResponse.image(image!) : FlickrResponse.error(.noImageAtUrl(error!))
                    
                    completion(flickrResponse)
                    
                })
                
                photoTask.resume()
                
            }
            
            
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
