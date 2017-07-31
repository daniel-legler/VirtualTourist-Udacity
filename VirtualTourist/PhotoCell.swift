//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    func setLoading() {
        self.loading.isHidden = false
        self.loading.startAnimating()
        self.image.image = UIImage()
    }
    
    func setLoaded() {
        self.loading.isHidden = true
        self.loading.stopAnimating()
    }
    
    func setEmpty() {
        self.loading.isHidden = true
        self.image.image = UIImage()
    }
}
