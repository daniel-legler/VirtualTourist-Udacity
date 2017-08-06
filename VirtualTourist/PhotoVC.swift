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

    var isLoading: Bool = false
    
    var coordinate = CLLocationCoordinate2D()
    var images = [UIImage]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupMap()
                
        guard let location = CDM.default.loadLocation(forCoordinate: coordinate, context: CDM.default.readContext) else { return }
        
        images = location.images()
        
        guard images.count != 0 else {
            
            refreshPhotos(){
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isLoading = self.images.count == 20 ? false : true
                }
            }
            
            return
            
        }
        
    }
    
    func refreshPhotos(_ completion: @escaping ()->()) {
        
        isLoading = true
        
        // Clear photos from CoreData
        CDM.default.clearPhotos(atCoordinate: coordinate)
        
        // Clear photos from this location instance
        images = []
        
        collectionView.reloadData()
        
        // Download new photos from Flickr
        FM.default.getPhotos(forCoordinate: coordinate) { (flickrResponse) in
            
            switch flickrResponse {
                
            case .error (let error):
                print(FM.default.handleError(error: error))
                completion()
                break
                
            case .image(let image):
                
                self.images.append(image)
                
                CDM.default.addNewImage(image: image, atCoordinate: self.coordinate)
                
                completion()
                
                break
            }
            
        }
    }
    
    func setupMap() {
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegionMake(coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
    
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        
        Loading.default.show(view)
        
        refreshPhotos() {
            
            DispatchQueue.main.async {
                
                Loading.default.hide()

                self.collectionView.reloadData()
                
                if self.images.count == 20 {
                    
                    self.newCollectionButton.isEnabled = true
                    self.isLoading = false

                }

            }
        }
    }
    
    // MARK: CollectionView Methods
    
    // Cells can be in 1 of 3 states:
    // 1. Displaying an image
    // 2. Loading an image
    // 3. Empty because a user deleted them
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        CDM.default.removePhoto(withImage: images[indexPath.row], atCoordinate: coordinate)
        
        images.remove(at: indexPath.row)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        
        cell.setEmpty()
        
        collectionView.moveItem(at: indexPath, to: IndexPath(item: 19, section: 0))
         
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        if images.count <= indexPath.row {
            if isLoading {
                
                cell.setLoading()
                
            } else {
                
                cell.setEmpty()
                
            }
            
        } else {
            cell.setLoaded()
            cell.image.image = images[indexPath.row]
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
