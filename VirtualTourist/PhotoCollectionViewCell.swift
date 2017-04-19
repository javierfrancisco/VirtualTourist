//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    func initCell(){
        
        //show the activity indicator
        
        
        

      //  locationImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
       // locationImage.backgroundColor = UIColor.red
        locationImage.layer.cornerRadius = 8.0
        locationImage.clipsToBounds = true
        locationImage.image = nil
        
        activityIndicator.startAnimating()
        activityIndicator.clipsToBounds = true
        self.alpha = 1.0
        
    }

    
}
