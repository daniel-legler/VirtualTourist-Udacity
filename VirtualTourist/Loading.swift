//
//  Loading.swift
//  VirtualTourist
//
//  Created by Daniel Legler on 7/1/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//
import UIKit

class Loading {
    
    static let `default` = Loading()
    
    private let activity = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    
    private let loadingView = UIView(frame: UIScreen.main.bounds)
    
    func show(_ view: UIView) {
        
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.startAnimating()
        
        loadingView.addSubview(activity)
        view.addSubview(loadingView)
        
    }
    
    func hide() {
        Loading.default.loadingView.removeFromSuperview()
    }
    
    
}
