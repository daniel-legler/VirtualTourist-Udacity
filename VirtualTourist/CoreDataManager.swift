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
    
    let ad = UIApplication.shared.delegate as! AppDelegate
    
    var readContext: NSManagedObjectContext {
        
        return ad.persistentContainer.viewContext
        
    }
    
    private var writeContext: NSManagedObjectContext {
        
        return ad.persistentContainer.newBackgroundContext()
        
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
    func createLocation(location: VTLocation) {
        
        let context = writeContext
        
        let locationObject = NSManagedObject(entity: locationEntity!, insertInto: context) as! Location
        
        locationObject.setValuesForKeys(["latitude": Double(location.coordinate.latitude),
                                         "longitude": Double(location.coordinate.longitude) ])
        
        save(context: context)
    }
    
    
    // Add photos to a specific location
    func savePhoto(with data: Data, to location: VTLocation) {
        
        let context = writeContext
        
        guard let locationObject = loadLocation(forCoordinate: location.coordinate, context: context) else {
            print("Can't find the location obbject in coredata with that coordinate")
            return
        }
        
        let photoObject = NSManagedObject(entity: photoEntity!, insertInto: context) as! Photo
        
        photoObject.setValue(data as NSData, forKey: "data")
        
        photoObject.setValue(UUID().uuidString, forKey: "id")
        
        locationObject.addToPhotos(photoObject)
        
        save(context: context)
        
    }
    
    
    // Delete one photo from a specific Location
    func removePhoto(with id: String, from location: VTLocation) {
        
        let context = writeContext
        
        guard let locationObject = loadLocation(forCoordinate: location.coordinate, context: context) else {
            print("Can't find the location obbject in coredata with that coordinate")
            return
        }
        
        guard let photos = locationObject.photos?.allObjects as? [Photo] else { return }
        
        for photo in photos {

            if photo.id! == id {
                
                locationObject.removeFromPhotos(photo)
                
                save(context: context)
                
            }
        }
    }
    
    func clearPhotos(from location: VTLocation) {
        
        let context = writeContext
        
        guard let locationObject = loadLocation(forCoordinate: location.coordinate, context: context) else {
            print("Can't find the location obbject in coredata with that coordinate")
            return
        }
        
        guard locationObject.photos != nil else { return }
        
        locationObject.removeFromPhotos(locationObject.photos!)
        
        save(context: context)
    }
    
    // MARK: Methods for reading data from model
    
    func loadAllMapPoints() -> [CLLocationCoordinate2D] {
        
        var mapPoints = [CLLocationCoordinate2D]()
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        do {
            let searchResults = try readContext.fetch(fetchRequest)
            
            for location in searchResults {

                mapPoints.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                
            }
        } catch {
            
            print("Error loading map pins")
            print(error.localizedDescription)
            
        }
        
        return mapPoints
    }
    
    func loadLocation (forCoordinate coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) -> Location? {
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        let predicate = NSPredicate(format: "(longitude == %@) AND (latitude == %@)", argumentArray: [coordinate.longitude, coordinate.latitude])
        
        fetchRequest.predicate = predicate
        
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
