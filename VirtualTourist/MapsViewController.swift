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

    var annotationsArray = [MKPointAnnotation]()
    var deleteMode = false
    var selectedPin: MKPointAnnotation? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUI()
        map.delegate = self
    }

    // Set UI with long tap gesture and Navigation Items
    func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(turnOnDeleteMode))
        deleteMode = false
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(action))
        longPress.minimumPressDuration = 1.0
        map.addGestureRecognizer(longPress)
        
    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        // If in delete mode, no adding pins!
        if deleteMode { return } else {
            if gestureRecognizer.state == .ended {
                let touchPoint = gestureRecognizer.location(in: map)
                let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinates
                map.addAnnotation(annotation)
                annotationsArray.append(annotation)
                // TODO: add to core data
            }
        }
    }
    // Adding in the Map Annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Add Map Annotation View
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = false
        annotationView.animatesDrop = true
        
        return annotationView
    }
    
    // Handle annotation selected, either delete or segue to next view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Annotation selected
        map.deselectAnnotation(view.annotation, animated: true)
        guard let annotation = view.annotation else {
            print("Didn't select an annotation")
            return
        }
        // Clear selected pin in case it is populated
        selectedPin = nil
        
        // Loop through annotations array to find the specific annotation selected
        for pin in annotationsArray {
            
            if annotation.coordinate.latitude == pin.coordinate.latitude && annotation.coordinate.longitude == pin.coordinate.longitude {
                selectedPin = pin
                
                // Check the mode in to see what to do with the selection
                if deleteMode {
                    //TODO: add to core data
                    self.map.removeAnnotation(annotation)
                    annotationsArray.remove(at: annotationsArray.index(of: pin)!)
                } else {
                    performSegue(withIdentifier: "segue", sender: selectedPin)
                }
            }
        }
    }
    
    func turnOnDeleteMode() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(turnOffDeleteMode))
        deleteMode = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(action))
        map.removeGestureRecognizer(longPress)
    }
    
    func turnOffDeleteMode() {
        setUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue" {
            let nextScene = segue.destination as? PhotoAlbumViewController
            nextScene?.annotation = (sender as! MKPointAnnotation)
        }
        
    }

}

