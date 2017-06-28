//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/28/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    var annotation: MKPointAnnotation? = nil
    
    @IBOutlet weak var smallMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smallMap.delegate = self
        smallMap.addAnnotation(annotation!)
    }
    
    
    
}
