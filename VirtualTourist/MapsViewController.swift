//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/24/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapsViewController: CoreDataViewController, MKMapViewDelegate {

    let delegate = UIApplication.shared.delegate as! AppDelegate
    var annotationsArray = [MKPointAnnotation]()
    var deleteMode = false
    var selectedPin: MKPointAnnotation? = nil
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = delegate.stack
        map.delegate = self
        
        //Create the fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let latitudeDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        let longitudeDescriptor = NSSortDescriptor(key: "longitude", ascending: false)
        fr.sortDescriptors = [latitudeDescriptor, longitudeDescriptor]
        
        // Init FetchResultsController
        fetchResultController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        loadPins()
        
        setUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
            self.map.addAnnotations(annotationsArray)
            print("added")
    }
    
    func loadPins() {
        do{
            let array = try! delegate.stack.context.fetch((fetchResultController?.fetchRequest)!) as! [Pin]
        
            for pin in array {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                annotationsArray.append(annotation)
            }
            
        } catch {
            fatalError("Error")
        }
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
                let ann = Pin(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, context: fetchResultController!.managedObjectContext)
                print("Just created a new pin \(ann)")
            }
        }
    }
    // Adding in the Map Annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Add Map Annotation View
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = false
            annotationView?.animatesDrop = true
        } else {
            annotationView?.annotation = annotation
        }
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

