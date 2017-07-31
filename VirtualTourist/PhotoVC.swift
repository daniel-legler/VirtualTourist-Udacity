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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
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
        
        // Clear photos from CoreData
        CDM.default.clearPhotos(from: location)
        
        // Clear photos from this location instance
        location.photos = []
        
        // DELETE UNDERSCORE TO TEST FLICKR API
        // Download new photos from Flickr
        FM.default._getPhotos(forCoordinate: location.coordinate) { (flickrResponse) in
            
            switch flickrResponse {
                
            case .error (let error):
                print(FM.default.handleError(error: error))
                completion()
                break
                
            case .image(let image):
                
                let vtPhoto = VTPhoto(image: image)
                
                self.location.photos.append(vtPhoto)
                
                CDM.default.savePhoto(with: vtPhoto.data, to: self.location)
                
                completion()
                
                break
            }
            
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
        
        refreshPhotos() {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
                self.newCollectionButton.isEnabled = self.location.photos.count == 20 ? true : false

            }
        }
    }
    
    // MARK: CollectionView Methods
    
    // Cells can be in 1 of 3 states:
    // 1. Displaying an image
    // 2. Loading an image
    // 3. Empty because a user deleted them
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        CDM.default.removePhoto(with: location.photos[indexPath.row].id, from: location)
        
        location.photos.remove(at: indexPath.row)

        
     /*   guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        cell.setEmpty()
        collectionView.moveItem(at: indexPath, to: IndexPath(item: 19, section: 0))
    */
         
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        if location.photos.count <= indexPath.row {
            cell.setLoading()
        } else {
            cell.setLoaded()
            cell.image.image = location.photos[indexPath.row].image
        }
        
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
