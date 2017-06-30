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

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var annotation: MKPointAnnotation? = nil
    var imageURLs = [String]()
    
    @IBOutlet weak var smallMap: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        smallMap.delegate = self
        smallMap.addAnnotation(annotation!)
        smallMap.centerCoordinate = (annotation?.coordinate)!
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func loadImages() {
        SavedItems.sharedInstance().imageArray.removeAll()
        Client.sharedInstance().getImageFromFlickr(long: (annotation?.coordinate.longitude)!, lat: (annotation?.coordinate.latitude
            )!) { (success, error) in
            if success {
                self.imageURLs = SavedItems.sharedInstance().imageArray
                self.collectionView.reloadData()
            } else {
                print(error?.userInfo as Any)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoAlbumViewCell
        let imageURL = self.imageURLs[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        let imageURLString = URL(string: imageURL)
        if let imageData = try? Data(contentsOf: imageURLString!) {
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: imageData)
            }
        } else {
            print("Image does not exist at \(imageURL)")
        }
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        
    }
}
