//
//  ViewController.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/9/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VirtualTouristMapViewController  : UIViewController {


    
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(VirtualTouristMapViewController.edit))
        
        navigationItem.rightBarButtonItems = [editButton]
        
        
        setInitLocation()
       
        
        mapView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
        
        
        ////
        //
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
         getAlbums()

        
    }
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            //Now use this coordinate to add annotation on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            //Set title and subtitle if you want
            annotation.title = "Title"
            annotation.subtitle = "subtitle"
            self.mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAlbums(){
    
        
        print(#function)
       // print("in getAlbum")
        
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
       
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext:fetchedResultsController!.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        
        print("Sections found: \(fc.sections?.count)")
        print("fetchedObjects found: \(fc.fetchedObjects?.count)")
        
        
        
    }
    
    func setInitLocation(){
        
        print("in setInitLocation")
        
        if let centerRegionDictionary = UserDefaults.standard.object(forKey: VTMap.Constants.CenterRegion) as? [String : Double]{
        
            let mapLatitude  = centerRegionDictionary[VTMap.Constants.MapLatitude]
            let mapLongitude = centerRegionDictionary[VTMap.Constants.MapLongitude]
            let mapSpanLat = centerRegionDictionary[VTMap.Constants.MapSpanLatDelta]
            let mapSpanLon = centerRegionDictionary[VTMap.Constants.MapSpanLongDelta]
            
            
            //zoom the map to the selected location
            let span = MKCoordinateSpanMake(mapSpanLat!, mapSpanLon!)
            let location = CLLocationCoordinate2DMake(mapLatitude!, mapLongitude!)
            let region = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region, animated: false)

            //end zooming to the location
            
            
        }
        
        

      
    }

    
    func edit(){
        
        print("in Edit")

       
        
    }
    
    

}

