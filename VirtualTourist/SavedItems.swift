//
//  SavedItems.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/28/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//
import Foundation

class SavedItems: NSObject {
    
    var imageArray = [String]()
    
    class func sharedInstance() -> SavedItems {
        struct Singleton {
            static var sharedInstance = SavedItems()
        }
        return Singleton.sharedInstance
    }
    
    
    
}
