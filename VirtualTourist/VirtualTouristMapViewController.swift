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
    var isEditButtonSelected = false
    var editButton : UIBarButtonItem?
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("In viewWillAppear")
        
        isEditButtonSelected = false
    }
    
    override func viewDidLoad() {
        
        print(#function)
        
        
        super.viewDidLoad()
        
        self.title = "Virtual Tourist"

        
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(VirtualTouristMapViewController.edit))
        
        navigationItem.rightBarButtonItems = [editButton!]
        
        
        setInitLocation()
       
        
        mapView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
        
        
    
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
            
            saveAlbum(coordinate: coordinate)
        }
    }
    
    func saveAlbum(coordinate : CLLocationCoordinate2D){
        
        
        var location = [String : Any]()
        
        let mapLatitude = String(format:"%.2f", coordinate.latitude)
        let mapLongitude = String(format:"%.2f", coordinate.longitude)
        
        location["latitude"] =  mapLatitude
        location["longitude"] = mapLongitude

        let stack = CoreDataStack.sharedInstance()
        let album = Album(location: location, context: stack.context)
        
        print("Just created a album: \(album)")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAlbums(){
        
        print(#function)
  
        let stack =  CoreDataStack.sharedInstance()
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")

        do {
            let albums = try stack.context.fetch(fr) as? [Album]
            
            print("num of albums found: \(albums?.count)")
            
            showAlbums(albums: albums!)

        } catch {
            print("unable to fetch albums")
        }
        
    }
    
    func showAlbums(albums : [Album]){
        
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        
        for album in albums{
        
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: Double(album.latitude), longitude: Double(album.longitude))
            
             print("album.latitude:\(album.latitude)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            
        }
    
    
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)

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
        
        print(#function)
        
        isEditButtonSelected = !isEditButtonSelected
        
        var buttonHeigth : CGFloat =  65

        if isEditButtonSelected {
            
            buttonHeigth *= -1
            editButton?.title = "Done"
        }else{
            editButton?.title = "Edit"
        }
        
        view.frame.origin.y += buttonHeigth

    }
    
    

}

