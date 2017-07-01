//
//  PhotoVC.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var location = Location()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
    }
    
    func setupMap() {
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegionMake(location.coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    
    }
}
