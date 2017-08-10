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

enum FlickrError:Error {
    case noImagesForLocation(Error)
    case noImageAtUrl
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

extension Int {
    func rand() -> Int {
        let rnd = Int(arc4random_uniform(UInt32(self)))
        return rnd == self ? self - 1 : rnd
    }
}

class FlickrManager {
    
    static let `default` = FlickrManager()
    
    var availablePages: Int?
    var previousPage: Int = 0
    
    var page: Int {
        guard availablePages != nil else { return 1 }
        switch availablePages! - previousPage {
        case 0:
            previousPage = 1
            return 1
        default:
            return previousPage + 1
        }
    }
    
    func getPhotos (forCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (FlickrResponse)->()) {
        
        let lat = Double(coordinate.latitude)
        let lon = Double(coordinate.longitude)
                
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=99c82a1df1fd9f61e3ce8e8b4205cb12&lat=\(lat)&lon=\(lon)&page=\(page)&per_page=20&radius=32&format=json&nojsoncallback=1")!

//        print("\(url.absoluteString)\n")
        
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
            guard let allPhotos = photosObj["photo"] as? [[String:Any]] else { return }
//            print("\(allPhotos.count) photos found")
            
            self.availablePages = photosObj["pages"] as? Int
            self.previousPage += 1
            
            for photo in allPhotos {
                
                let fID = photo["farm"]!
                guard let serverID = photo["server"]! as? String else { print("server"); continue }
                guard let photoID = photo["id"]! as? String else { print("id"); continue }
                guard let secret = photo["secret"]! as? String else { print("secret"); continue }
                
                let flickrURL = FlickrPhotoURL(farmID: String(describing: fID) , serverID: serverID, photoID: photoID, secret: secret)
                
                self.downloadFlickrImage(url: flickrURL.url, completion: { (flickrResponse) in
                    completion(flickrResponse)
                })
            }
        }
        task.resume()
    }
    
    
    func downloadFlickrImage(url: URL, completion: @escaping (FlickrResponse)->()) {
        
        let photoTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            
            guard let data = data else { completion(.error(.noImageAtUrl)); return }
            
            let image = UIImage(data: data)
            
            let flickrResponse = image != nil ? FlickrResponse.image(image!) : FlickrResponse.error(.noImageAtUrl)
            
            completion(flickrResponse)
            
        })
        
        photoTask.resume()

    }
    
    func handleError (error: FlickrError) -> String {
        switch error {
            case .connectionError(_):
                return "Connection Error"
            case .noImagesForLocation(_):
                return "No images found near that location"
            case .noImageAtUrl(_):
                return "Not a valid image URL"
            case .invalidCoordinates(_):
                return "Invalid coordinates from map"
        }
        
    }
}
