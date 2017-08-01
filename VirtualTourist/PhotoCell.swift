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
        self.isUserInteractionEnabled = false
    }
    
    func setLoaded() {
        self.loading.stopAnimating()
        self.isUserInteractionEnabled = true

    }
    
    func setEmpty() {
        self.loading.stopAnimating()
        self.image.image = UIImage()
        self.isUserInteractionEnabled = false
    }
}
