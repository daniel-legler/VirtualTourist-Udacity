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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dest = segue.destination as? PhotoVC else {
            return
        }
        
        dest.location.coordinate = selectedLocation
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
        
        guard let annotation = view.annotation as? MKPointAnnotation else {
            return
        }
        
        selectedLocation = annotation.coordinate
        
        performSegue(withIdentifier: "ShowImages", sender: nil)
        
    }
    
}
