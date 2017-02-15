//
//  FlickrImage.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation


struct FlickrImage {


    let imageId : String?
    let urlM : String?

    
    init(dictionary: [String:AnyObject]) {
        
        urlM = dictionary[FlickrConstants.FlickrResponseKeys.MediumURL]  as?  String
        imageId = dictionary[FlickrConstants.FlickrResponseKeys.Photo] as?  String
        
    }
}
