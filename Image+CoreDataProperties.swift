//
//  Image+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by zenkiu on 3/29/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var album: Album?

}
