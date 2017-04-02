//
//  VirtualTouristMap.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import UIKit
import MapKit

extension VirtualTouristMapViewController  :  MKMapViewDelegate  {

    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("#function")
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("pin was touched")
        
        performSegue(withIdentifier: "locationGallerySegue", sender: view.annotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier == "locationGallerySegue") {
            
            
            let selectedLocation = sender as! MKAnnotation
            
            let controller = segue.destination as!
            PhotoAlbumMapViewController
            controller.selectedLocation = selectedLocation
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        print("location did change")
        
        
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
        

    }
    
}
