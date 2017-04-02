//
//  Album+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by zenkiu on 3/29/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album");
    }

    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Album {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
