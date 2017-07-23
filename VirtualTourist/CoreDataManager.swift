//
//  CoreDataManager.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/6/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// Look up all map pins to display in map view
// Add a new pin to the map view
// Save a list of images to a pinned location
// Save a change to the list of images
//

typealias CDM = CoreDataManager
class CoreDataManager {
    
    // MARK: Properties
    static let `default` = CoreDataManager()
    
    private var context: NSManagedObjectContext {
        
        let ad = UIApplication.shared.delegate as! AppDelegate
        
        return ad.persistentContainer.viewContext
        
    }
    
    private var locationEntity: NSEntityDescription? {
        
        return NSEntityDescription.entity(forEntityName: "Location", in: context)
        
    }
    
    // MARK: Methods for writing data to model
    
    // Delete one photo from a specific Location
    // Add photos to a specific location
    
    
    
    // Create a new map pin and CoreData Location object with only the latitude and longitude set
    
    func createLocation(location: VTLocation) {
        
        let locationObject = NSManagedObject(entity: locationEntity!, insertInto: context) as! Location
        
        locationObject.setValuesForKeys(["latitude": Double(location.coordinate.latitude),
                                         "longitude": Double(location.coordinate.longitude) ])
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Couldn't save to CoreData. \(error.localizedDescription)")
            
        }
    }
    
//    func removePhoto(photoAsData: Data, location: Location) -> Bool {
//        
//        for photo in location.photos! {
//
//            guard let photoData = photo as? Data else { return false }
//            
//            print("Converted photo to data")
//            
//            if photoAsData == photoData {
//                location.removeFromPhotos(photo)
//                return true
//            }
//        }
//        
//        return false
//    }

    func saveLocation(location: VTLocation) {
        
        let existingLocationObject = loadLocation(forCoordinate: location.coordinate)
        
        let newLocationObject = NSManagedObject(entity: locationEntity!, insertInto: context) as! Location
        
        let locationObject = existingLocationObject == nil ? newLocationObject : existingLocationObject!
        
        locationObject.setValuesForKeys(["latitude": Double(location.coordinate.latitude),
                                         "longitude": Double(location.coordinate.longitude) ])
        
        //locationObject.photos?.addingObjects(from: location.photoData)
        
        locationObject.removeFromPhotos(locationObject.photos!)
        
        // Set the locationOject photo set equal to the location.photos photo set.
        
//        for photo in location.photos {
        
//            locationObject.addToPhotos(UIImagePNGRepresentation(photo))
//            
//        }
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Couldn't save to CoreData. \(error.localizedDescription)")
            
        }
    }
    
//    func saveLocation(location: VTLocation) {
//        
//        let existingLocationObject = loadLocationObject(forCoordinate: location.coordinate)
//        
//        let newLocationObject = NSManagedObject(entity: locationEntity!, insertInto: context) as! Location
//        
//        let locationObject = existingLocationObject == nil ? newLocationObject : existingLocationObject!
//        
//        let savedPhotoData = NSKeyedArchiver.archivedData(withRootObject: location.photoData)
//
//        locationObject.setValuesForKeys(["images": savedPhotoData,
//                                      "latitude": Double(location.coordinate.latitude),
//                                      "longitude": Double(location.coordinate.longitude) ])
//        do {
//            
//            try context.save()
//            
//        } catch {
//            
//            print("Couldn't save to CoreData. \(error.localizedDescription)")
//            
//        }
//    }
    
//    func loadVTLocation (forCoordinate coordinate: CLLocationCoordinate2D) -> VTLocation {
//        
//        let vtLocation = VTLocation()
//        
//        guard let location = loadLocationObject(forCoordinate: coordinate) else {
//            return VTLocation()
//        }
//        
//        vtLocation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        
//        guard let imageArray = NSKeyedUnarchiver.unarchiveObject(with: location.images! as Data) as? NSArray else {
//            print("Couldn't find core data object")
//            return vtLocation
//        }
//        
//        for imageData in imageArray {
//            guard let imageData = imageData as? Data else { print("Couldn't convert to data"); return vtLocation   }
//            guard let image = UIImage(data: imageData) else { print("Couldn't form UIImage from data"); return vtLocation }
//            vtLocation.photos.append(image)
//        }
//        
//        return vtLocation
//    }
    
    // MARK: Methods for reading data from model
    
    func loadAllMapPoints() -> [CLLocationCoordinate2D] {
        
        var mapPoints = [CLLocationCoordinate2D]()
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            
            for location in searchResults {

                mapPoints.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                
            }
        } catch {
            
            print("Error loading map pins")
            print(error.localizedDescription)
            
        }
        
        return mapPoints
    }
    
    func loadLocation (forCoordinate coordinate: CLLocationCoordinate2D) -> Location? {
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        let predicate = NSPredicate(format: "(longitude == %@) AND (latitude == %@)", argumentArray: [coordinate.longitude, coordinate.latitude])
        
        fetchRequest.predicate = predicate
        
        do {
            
            let searchResults = try context.fetch(fetchRequest)
            
            print("\(searchResults.count) result(s) found for that lat/lon")
            
            guard let location = searchResults.first else { return nil }
            
            return location
            
        } catch {
            
            print("Error fetching location objects")
            print(error.localizedDescription)
            
        }
        
        return nil
        
    }
    
//    func loadLocationObject (forCoordinate coordinate: CLLocationCoordinate2D) -> Location? {
//        
//        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
//        
//        let predicate = NSPredicate(format: "(longitude == %@) AND (latitude == %@)", argumentArray: [coordinate.longitude, coordinate.latitude])
//        
//        fetchRequest.predicate = predicate
//        
//        do {
//            
//            let searchResults = try context.fetch(fetchRequest)
//            
//            print("\(searchResults.count) result(s) found for that lat/lon")
//            
//            guard let location = searchResults.first else { return nil }
//            
//            return location
//            
//        } catch {
//            
//            print("Error loading location objects")
//            print(error.localizedDescription)
//            
//        }
//        
//        return nil
//    }
//    
//    func loadVTLocation2 (forCoordinate coordinate: CLLocationCoordinate2D) -> VTLocation {
//        
//        let vtLocation = VTLocation()
//        
//        guard let location = loadLocationObject(forCoordinate: coordinate) else {
//            return VTLocation()
//        }
//        
//        vtLocation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//        
//        guard let imageArray = location.images as? NSArray else {
//            print("Couldn't convert images to NSArray")
//            return VTLocation()
//        }
//        
//        for imageData in imageArray {
//            guard let imageData = imageData as? Data else { print("Couldn't convert to data"); return vtLocation   }
//            guard let image = UIImage(data: imageData) else { print("Couldn't form UIImage from data"); return vtLocation }
//            vtLocation.photos.append(image)
//        }
//        
//        return vtLocation
//    }


}
