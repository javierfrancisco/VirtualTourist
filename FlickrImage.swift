//
//  Image+CoreDataClass.swift
//  VirtualTourist
//
//  Created by zenkiu on 3/29/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import CoreData


public class FlickrImage: NSManagedObject {
    
    var deleteSw = false
    
    convenience init(dictionary: [String:AnyObject], album: Album,  context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "FlickrImage", in: context) {
            
            self.init(entity: ent, insertInto: context)

            self.url = dictionary[FlickrConstants.FlickrResponseKeys.MediumURL]  as?  String
            self.name = dictionary[FlickrConstants.FlickrResponseKeys.Photo] as?  String
            self.creationDate = Date() as NSDate?
            self.album = album
            
        } else {
            fatalError("Unable to find Entity name!")
        }
        

    }
   

    
}
