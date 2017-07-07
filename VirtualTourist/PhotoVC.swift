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

class PhotoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var location = VTLocation()
    var isNewPin: Bool = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        Loading.default.show(mapView)
        
        setupMap()
        
        Loading.default.hide()

        // DELETE UNDERSCORE TO TEST FLICKR API
        FM.default._getPhotos(forCoordinate: location.coordinate) { (flickrResponse) in
            
            switch flickrResponse {
                case .error (let error):
                    print(FM.default.handleError(error: error))
                    break
                
                case .images(let images):
                    self.location.photos = images
                    break
            }
            
            CDM.default.saveLocation(location: self.location)

        }
    }
    
    func setupMap() {
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegionMake(location.coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location.coordinate
    
        mapView.addAnnotation(annotation)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return location.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.image.image = location.photos[indexPath.row]
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3//UIScreen.main.bounds.width -
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 3.0
        let dimension: CGFloat = (UIScreen.main.bounds.width - (2 * space)) / 3.0
        return CGSize(width: dimension, height: dimension)
    }
    
    
    
    
    
}
