//
//  VTPhoto.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/22/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

extension Photo {
    func image() -> UIImage {
        return UIImage(data: (self.data ?? NSData()) as Data) ?? UIImage()
    }
}

