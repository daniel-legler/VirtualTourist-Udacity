//
//  MapVC.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, MKMapViewDelegate {

    // TODO: need to load existing annotation points from CoreData
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation = CLLocationCoordinate2D()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        reloadMapAnnotations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dest = segue.destination as? PhotoVC else { return }
        
        dest.location.coordinate = selectedLocation
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            // Add pin to Map
            
            let mapTouchPoint = sender.location(in: mapView)
            
            let newAnnotation = MKPointAnnotation()
            
            newAnnotation.coordinate = mapView.convert(mapTouchPoint, toCoordinateFrom: mapView)
            
            mapView.addAnnotation(newAnnotation)
            
            // Save pin to CoreData
            
            let location = VTLocation(coord: newAnnotation.coordinate)
            
            CDM.default.createLocation(location: location)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? MKPointAnnotation else {
            return
        }
        
        selectedLocation = annotation.coordinate
        
        performSegue(withIdentifier: "ShowImages", sender: nil)
        
    }
    
    func reloadMapAnnotations() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        let locations = CDM.default.loadAllMapPoints()
        
        for point in locations {
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = point
            
            mapView.addAnnotation(annotation)
        
        }
        
    }
    
}
