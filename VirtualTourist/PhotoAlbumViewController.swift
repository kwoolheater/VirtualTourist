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
import CoreData

class PhotoAlbumViewController: CoreDataViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var annotation: MKPointAnnotation? = nil
    var imageURLs = [Data]()
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        // Create a fetch request to specify what objects this fetchedResultsController tracks.
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        fr.sortDescriptors = [NSSortDescriptor(key: "imageData", ascending: true)]
        
        // Specify that we only want the photos associated with the tapped pin. (pin is the relationships)
        fr.predicate = NSPredicate(format: "pin = %@", self.annotation!)
        
        // Create and return the FetchedResultsController
        return NSFetchedResultsController(fetchRequest: fr, managedObjectContext: self.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }()
    
    let stack = (UIApplication.shared.delegate as! AppDelegate).stack
    
    @IBOutlet weak var smallMap: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if this pin has photos stored in Core Data.
        do {
            try fetchResultController?.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
        
        let fetchedObjects = fetchResultController?.fetchedObjects
        
        if fetchedObjects == nil  {
            loadImages()
            self.collectionView.reloadData()
        } else {
            SavedItems.sharedInstance().imageArray.removeAll()
            SavedItems.sharedInstance().imageArray = fetchedObjects! as! [Data]
            collectionView.reloadData()
        }
        imageURLs.removeAll()
        smallMap.delegate = self
        smallMap.addAnnotation(annotation!)
        smallMap.centerCoordinate = (annotation?.coordinate)!
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func loadImages() {
        SavedItems.sharedInstance().imageArray.removeAll()
        Client.sharedInstance().getImageFromFlickr(long: (annotation?.coordinate.longitude)!, lat: (annotation?.coordinate.latitude
            )!) { (success, photo, error) in
            // Handle no photos at this location
            if success {
                if photo {
                    self.label.text = "There are no photos at this location."
                } else {
                    self.loadImageData(SavedItems.sharedInstance().imageURLArray)
                    self.collectionView.reloadData()
                }
            } else {
                print(error?.userInfo as Any)
            }
        }
    }
    
    func loadImageData(_ imageURLs: [String]) {
        for url in imageURLs {
            let imageURLString = URL(string: url)
            if let imageData = try? Data(contentsOf: imageURLString!) {
                //let image = Images(imageData: imageData as NSData, context: stack.context)
                SavedItems.sharedInstance().imageArray.append(imageData)
                self.imageURLs.append(imageData)
                do {
                    try stack.context.save()
                } catch {
                    print("error saving images in data")
                }
            } else {
                print("Image does not exist at \(url)")
            }
        }
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        imageURLs = SavedItems.sharedInstance().imageArray
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoAlbumViewCell
        let imageData = self.imageURLs[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        DispatchQueue.main.async {
            cell.imageView.image = UIImage(data: imageData)
        }

        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        
    }
}
