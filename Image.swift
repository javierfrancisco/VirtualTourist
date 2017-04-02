//
//  Image+CoreDataClass.swift
//  VirtualTourist
//
//  Created by zenkiu on 3/29/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import CoreData


public class Image: NSManagedObject {

    
    convenience init(text: String = "New Image", context: NSManagedObjectContext) {
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Image", in: context) {
            self.init(entity: ent, insertInto: context)
            self.name = "name"
            self.url = "url"
            self.creationDate = Date() as NSDate?
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

    
}
