
//
//  CoreDataViewController.swift
//  VirtualTourist
//
//  Created by Kiyoshi Woolheater on 6/30/17.
//  Copyright © 2017 Kiyoshi Woolheater. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataViewController: UIViewController {
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet{
            fetchResultController?.delegate = self as! NSFetchedResultsControllerDelegate
            executeSearch()
        }
    }
    
    init (fetchResultsController fc: NSFetchedResultsController<NSFetchRequestResult>){
        fetchResultController = fc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


extension CoreDataViewController {
    
    func executeSearch() {
        if let fc = fetchResultController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchResultController)")
            }
        }
    }
}
