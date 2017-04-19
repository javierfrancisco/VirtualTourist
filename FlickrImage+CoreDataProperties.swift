//
//  FlickrImage+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by zenkiu on 4/7/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import CoreData


extension FlickrImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrImage> {
        return NSFetchRequest<FlickrImage>(entityName: "FlickrImage");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var album: Album?

}
