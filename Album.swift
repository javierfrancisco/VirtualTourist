//
//  Album+CoreDataClass.swift
//  VirtualTourist
//
//  Created by zenkiu on 3/29/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import CoreData


public class Album: NSManagedObject {

    
    
    convenience init(location: [String : Any] , context: NSManagedObjectContext) {
        
        
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Album", in: context) {
            
            self.init(entity: ent, insertInto: context)
            let latStr = location[VTMap.Location.Latitude] as! String
            let lonStr = location[VTMap.Location.Longitude] as! String
                
            self.latitude = Float(latStr)!
            self.longitude = Float(lonStr)!
            self.creationDate = Date() as NSDate?
            
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
}
