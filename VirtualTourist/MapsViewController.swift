//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/24/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate {

    var deleteMode = false
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: Add action
        setUpUI()
        addLongPress()

        
    }

    func setUpUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    }
    
    func addLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(action))
        longPress.minimumPressDuration = 1.0
        map.addGestureRecognizer(longPress)
    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: map)
            let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            map.addAnnotation(annotation)
        }
    }

}

