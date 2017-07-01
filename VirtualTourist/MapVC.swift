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

    // Will need to load existing annotation points from CoreData
    // Will need to add annotations when map is long pressed
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowImages" {
            
        }
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let mapTouchPoint = sender.location(in: mapView)
            
            let newAnnotation = MKPointAnnotation()
            
            newAnnotation.coordinate = mapView.convert(mapTouchPoint, toCoordinateFrom: mapView)
            
            mapView.addAnnotation(newAnnotation)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Look up coordinate in CoreData, prepare for segue to start loading photos on next page, and go to photo view
            //        view.annotation?.coordinate
        
    }
    
}
