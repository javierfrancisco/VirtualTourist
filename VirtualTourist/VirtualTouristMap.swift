//
//  VirtualTouristMap.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import UIKit
import MapKit
import CoreData


extension VirtualTouristMapViewController  :  MKMapViewDelegate  {

    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print(#function)
        
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
        
        if let selectedLocation = view.annotation {
            
            let album = getAlbumByLocation(coordinate: selectedLocation.coordinate)
            
            if(self.isEditButtonSelected){
            
                //delete pins
                print("delete this pin")
                deletePinLocation(album)
                self.mapView.removeAnnotation(selectedLocation)
                
            }else{
                //go to next view
                performSegue(withIdentifier: "locationGallerySegue", sender: album)
                
            }
            
            
            mapView.deselectAnnotation(view.annotation, animated: false)
        
        }
        
    }
    
    func deletePinLocation(_ album : Album){
    
        let stack = CoreDataStack.sharedInstance()
        
        stack.context.delete(album)
        saveContext()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier == "locationGallerySegue") {
            
            let controller = segue.destination as!
            PhotoAlbumMapViewController
            controller.album = sender as! Album?
        }
    }
    
    func getAlbumByLocation(coordinate : CLLocationCoordinate2D) -> Album{
        
        var album : Album!
        
        let mapLatitude = String(format:"%.2f", coordinate.latitude)
        let mapLongitude = String(format:"%.2f", coordinate.longitude)
        
        let stack = CoreDataStack.sharedInstance()
    
        
        // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")

        print("latitude:\(mapLatitude)")
        
     
        let pred = NSPredicate(format: "latitude = %@ AND longitude = %@", argumentArray: [Float(mapLatitude)!, Float(mapLongitude)!])
        
        fr.predicate = pred
        

        
        do {
            if let albums = try stack.context.fetch(fr) as? [Album]{
            
                print("num of album found: \(albums.count)")
                
                if albums.count > 0 {
                    album = albums.first
                    
                    print("num of images in album found: \(album.images?.count)")
                }
            }
            
   
        } catch {
            print("unable to fetch album")
        }
        
        return album
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
        
       /* print("mapLatitude:\(mapLatitude)")
        print("mapLongitude:\(mapLongitude)" )
        print("mapSpanLat:\(mapSpanLat)")
        print("mapSpanLon:\(mapSpanLon)") */
        
        
        UserDefaults.standard.set(centerRegionDictionary, forKey: VTMap.Constants.CenterRegion)
        

    }
    
}
