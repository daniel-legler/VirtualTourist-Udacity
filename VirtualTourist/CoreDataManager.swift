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
    
    // MARK: Methods
    
    func saveLocation(location: VTLocation) {
        
        let newLocation = NSManagedObject(entity: locationEntity!, insertInto: context)
        
        let savedPhotoData = NSKeyedArchiver.archivedData(withRootObject: location.photoData)

        newLocation.setValuesForKeys(["images": savedPhotoData,
                                      "latitude": Double(location.coordinate.latitude),
                                      "longitude": Double(location.coordinate.longitude) ])
        do {
            
            try context.save()
            
        } catch {
            
            print("Couldn't save to CoreData. \(error.localizedDescription)")
            
        }
    }
    
    func loadMapPoints() -> [CLLocationCoordinate2D] {
        
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
    
    func loadVTLocation (forCoordinate coordinate: CLLocationCoordinate2D) -> VTLocation {
        
        var vtLocation = VTLocation()
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        let predicate = NSPredicate(format: "longitude == \(coordinate.longitude) AND latitude == \(coordinate.latitude)", argumentArray: nil)

        fetchRequest.predicate = predicate
        
        do {
            
            let searchResults = try context.fetch(fetchRequest)
            
            print(searchResults)
            
        } catch {
            
            print("Error loading location objects")
            print(error.localizedDescription)
            
        }

//        guard let savedCoreDataObject = NSKeyedUnarchiver.unarchiveObject(with: coreDataObject) as? NSArray else {
//            print("Couldn't find core data object")
//            return
//        }

        return VTLocation()
    }
    
    
    
    
    
    
    
    
}
