//
//  Images+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/29/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import CoreData

@objc(Images)
public class Images: NSManagedObject {
    
    convenience init(imageData: NSData, context:NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Image", in: context){
            self.init(entity: ent, insertInto: context)
            self.imageData = imageData
        } else {
            fatalError("Could not find Entity Name!")
        }
    }

}
