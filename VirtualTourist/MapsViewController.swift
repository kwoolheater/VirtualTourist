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

    var annotations = [MKPointAnnotation]()
    var deleteMode = false
    var selectedPin: MKPointAnnotation? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: Add action
        setUI()
        map.delegate = self
    }

    func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(turnOnDeleteMode))
        
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
            annotations.append(annotation)
        }
    }
    // Adding in the Map Annotation View
    
    
    // TODO: work on delete pins
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = false
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        map.deselectAnnotation(view.annotation, animated: true)
        guard let annotation = view.annotation else {
            print("Didn't select an annotation")
            return
        }
        
        selectedPin = nil
        
        for pin in annotations {
            var numOfPins = 0
            
            if annotation.coordinate.latitude == pin.coordinate.latitude && annotation.coordinate.longitude == pin.coordinate.longitude {
                selectedPin = pin
                if deleteMode {
                    print("deleting pin!")
                    self.map.removeAnnotation(annotation)
                    annotations.remove(at: numOfPins )
                }
            }
            numOfPins += 1
            
        }
        
        
    }
    
    func turnOnDeleteMode() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        deleteMode = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(action))
        map.removeGestureRecognizer(longPress)
    }

}

