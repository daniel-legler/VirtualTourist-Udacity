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
    
    private var container: NSPersistentContainer {
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
    }
    
    var readContext: NSManagedObjectContext {
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }

    private var locationEntity: NSEntityDescription? {
        
        return NSEntityDescription.entity(forEntityName: "Location", in: readContext)
        
    }
    
    private var photoEntity: NSEntityDescription? {
        
        return NSEntityDescription.entity(forEntityName: "Photo", in: readContext)
        
    }
    
    // MARK: Methods for modifying data
    
    private func save(context: NSManagedObjectContext) {
        do { try context.save() }
        catch { print("Couldn't save to CoreData. \(error.localizedDescription)") }
    }
    
    
    
    // Create a new map pin and CoreData Location object with only the latitude and longitude set
    func createLocation(atCoordinate: CLLocationCoordinate2D) {
        
        let location = Location(context: readContext)
        
        location.latitude = atCoordinate.latitude 
        
        location.longitude = atCoordinate.longitude
        
        save(context: readContext)
        
    }
    
    
    // Add photos to a specific location
    func addNewImage(image: UIImage, atCoordinate: CLLocationCoordinate2D) {
        
//        container.performBackgroundTask { (context) in
        
            guard let locationObject = self.loadLocation(forCoordinate: atCoordinate, context: readContext) else {
                print("Can't find the location obbject in coredata with that coordinate")
                return
            }
            
            let photoObject = Photo(context: readContext)
            
            photoObject.setValue(image.data as NSData, forKey: "data")
        
            photoObject.location = locationObject
        
            self.save(context: readContext)

//        }
        
    }
    
    
    // Delete one photo from a specific Location
    func removePhoto(withImage: UIImage, atCoordinate: CLLocationCoordinate2D) {
        
//        container.performBackgroundTask { (context) in
        
            guard let locationObject = self.loadLocation(forCoordinate: atCoordinate, context: readContext) else {
                print("Can't find the location obbject in coredata with that coordinate")
                return
            }
            
            for case let photo as Photo in locationObject.photos! {
                
                if photo.image() == withImage {
                    print("Found image to delete")
                    readContext.delete(photo)
                    
                    self.save(context: readContext)
                    
                }
            }

//        }
    }
    
    func clearPhotos(atCoordinate: CLLocationCoordinate2D) {
        
//        container.performBackgroundTask { (context) in
        
            guard let locationObject = self.loadLocation(forCoordinate: atCoordinate, context: readContext) else {
                print("Can't find the location obbject in coredata with that coordinate")
                return
            }
            
            guard locationObject.photos != nil else { return }
            
            for case let photo as Photo in locationObject.photos! {
                readContext.delete(photo)
            }
            
            self.save(context: readContext)

//        }
        
    }
    
    // MARK: Methods for reading data from model
    
    func loadAllMapPoints() -> [CLLocationCoordinate2D] {
        
        var mapPoints = [CLLocationCoordinate2D]()
        
        do {
            
            let locations = try readContext.fetch(Location.fetchRequest())
            
            for case let location as Location in locations {

                mapPoints.append(location.coordinate())
                
            }
        } catch {
            
            print("Error loading map pins")
            print(error.localizedDescription)
            
        }
        
        return mapPoints
    }
    
    func loadLocation (forCoordinate coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) -> Location? {
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "(longitude == %@) AND (latitude == %@)", argumentArray: [coordinate.longitude, coordinate.latitude])
        
        do {
            
            let searchResults = try context.fetch(fetchRequest)
//            print("\(searchResults.count) result(s) found for that lat/lon")
            
            guard let location = searchResults.first else { return nil }
            
            return location
            
        } catch {
            
            print("Error fetching location objects")
            print(error.localizedDescription)
            
        }
        
        return nil
        
    }

}
