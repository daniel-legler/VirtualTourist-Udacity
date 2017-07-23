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
        
        Loading.default.show(view)
        
        setupMap()
        
        guard let loadedLocation = CDM.default.loadLocation(forCoordinate: location.coordinate) else { return }
        
        location = VTLocation(location: loadedLocation)

        if location.photos.count == 0 {
            refreshPhotos(){
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    Loading.default.hide()
                }
            }
        } else { Loading.default.hide() }
        
    }
    
    func refreshPhotos(_ completion: @escaping ()->()) {
        
        // DELETE UNDERSCORE TO TEST FLICKR API
        FM.default._getPhotos(forCoordinate: location.coordinate) { (flickrResponse) in
            
            switch flickrResponse {
                
            case .error (let error):
                print(FM.default.handleError(error: error))
                completion()
                break
                
            case .image(let image):
                self.location.photos.append(VTPhoto(image: image))
                completion()
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
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        
        Loading.default.show(view)
        
        refreshPhotos() {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
                Loading.default.hide()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        location.photos.remove(at: indexPath.row)
        
        collectionView.deleteItems(at: [indexPath])
        
        CDM.default.saveLocation(location: location)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return location.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.image.image = location.photos[indexPath.row].image
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
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
