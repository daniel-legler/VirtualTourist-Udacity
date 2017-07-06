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
    
    static let `default` = CoreDataManager()
    
    private func getContext() -> NSManagedObjectContext {
        
        let ad = UIApplication.shared.delegate as! AppDelegate
        
        return ad.persistentContainer.viewContext
    }
    
    func saveLocation(location: VTLocation) {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        
        let newLocation = NSManagedObject(entity: entity!, insertInto: context)
        
        newLocation.setValuesForKeys(["images": location.photoData(),
                                      "latitude": Double(location.coordinate.latitude),
                                      "longitude": Double(location.coordinate.longitude) ])
        
        do {
            try context.save()
        } catch {
            print("Couldn't save to CoreData. \(error.localizedDescription)")
        }
        
        // TO EXTRACT:
//        var coreDataObject = NSKeyedArchiver.archivedData(withRootObject: location.photoData)
//        guard let savedCoreDataObject = NSKeyedUnarchiver.unarchiveObject(with: coreDataObject) as? NSArray else {
//            print("Couldn't find core data object")
//            return
//        }
        
    }
    
    
    
}
