//
//  ViewController.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/9/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import UIKit
import MapKit

class VirtualTouristMapViewController  : UIViewController {


    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(VirtualTouristMapViewController.edit))
        
        navigationItem.rightBarButtonItems = [editButton]
        
        
        setInitLocation()
        
        mapView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)

        
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
    
    func setInitLocation(){
        
        print("in setInitLocation")
        
        if let centerRegionDictionary = UserDefaults.standard.object(forKey: VTMap.Constants.CenterRegion) as? [String : Double]{
        
            let mapLatitude  = centerRegionDictionary[VTMap.Constants.MapLatitude]
            let mapLongitude = centerRegionDictionary[VTMap.Constants.MapLongitude]
            let mapSpanLat = centerRegionDictionary[VTMap.Constants.MapSpanLatDelta]
            let mapSpanLon = centerRegionDictionary[VTMap.Constants.MapSpanLongDelta]
            
            print("mapLatitude:\(mapLatitude)")
            print("mapLongitude:\(mapLongitude)")
            print("mapSpanLat:\(mapSpanLat)")
            print("mapSpanLon:\(mapSpanLon)")
            
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

        let mapLatitude  = mapView.region.center.latitude
        let mapLongitude = mapView.region.center.longitude
        let mapSpanLat = mapView.region.span.latitudeDelta
        let mapSpanLon = mapView.region.span.longitudeDelta
        
        var centerRegionDictionary = [String:Double]()
        
        centerRegionDictionary[VTMap.Constants.MapLatitude] = mapLatitude
        centerRegionDictionary[VTMap.Constants.MapLongitude] = mapLongitude
        centerRegionDictionary[VTMap.Constants.MapSpanLatDelta] = mapSpanLat
        centerRegionDictionary[VTMap.Constants.MapSpanLongDelta] = mapSpanLon
        
        print("mapLatitude:\(mapLatitude)")
        print("mapLongitude:\(mapLongitude)" )
        print("mapSpanLat:\(mapSpanLat)")
        print("mapSpanLon:\(mapSpanLon)")
        
   
        UserDefaults.standard.set(centerRegionDictionary, forKey: VTMap.Constants.CenterRegion)

        
        //Mode to next view controller
        //locationGallerySegue
        
        //performSegue(withIdentifier: "locationGallerySegue", sender: self)
        
    }
    
    

}

