//
//  Images+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/29/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var pin: Pin?

}
