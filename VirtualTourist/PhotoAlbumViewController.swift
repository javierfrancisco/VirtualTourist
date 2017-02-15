//
//  LocationGalleryViewController.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation


import UIKit
import MapKit

class PhotoAlbumViewController: UICollectionViewController, MKMapViewDelegate  {

    @IBOutlet weak var mapVIew: MKMapView!
    
    var selectedLocation : MKAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        print("in PhotoAlbumViewController")
        initLocation()
        
        loadImages()
        
       
    }
    
    func loadImages(){
        
        
        if selectedLocation != nil {
            
            let mapLatitudeDegrees  = selectedLocation?.coordinate.latitude
            let mapLongitudeDegrees = selectedLocation?.coordinate.longitude
            
            var location = [String : Any]()
            
            let mapLatitude = String(format:"%.2f", mapLatitudeDegrees!)
            let mapLongitude = String(format:"%.2f", mapLongitudeDegrees!)
            
            location["latitude"] =  mapLatitude
            location["longitude"] = mapLongitude
                
                
                FlickrClient.sharedInstance().getFlickImagesByLocation(location: location as [String : AnyObject]){ success, flickrImages, error in
                    
                    print("getFlickImagesByLocation call completed>")
                    print("images count : \(flickrImages)")
                 
                    for flickr in flickrImages! {
                        
                        print("url:\(flickr.urlM)")
                        
                    }
                    
            }
    
        }
        
        
                   
    }
    
    func initLocation(){

        if selectedLocation != nil {
        
        let mapLatitude  = selectedLocation?.coordinate.latitude
        let mapLongitude = selectedLocation?.coordinate.longitude
        let mapSpanLat : Double = 1
        let mapSpanLon : Double  = 1
        
        //zoom the map to the selected location
        let span = MKCoordinateSpanMake(mapSpanLat, mapSpanLon)
        let location = CLLocationCoordinate2DMake(mapLatitude!, mapLongitude!)
        let region = MKCoordinateRegionMake(location, span)
        self.mapVIew.setRegion(region, animated: false)
    
            
            mapVIew.addAnnotation(selectedLocation!)
        }
    }
    
    
    
    // Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // print("number of memes: \(memes.count)")
        // return memes.count
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("-in cellForItemAtIndexPath-")
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        
        /*
        let meme = self.memes[indexPath.row]
        
 
        
        // Set the name and image
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.contentMode=UIViewContentMode.scaleAspectFit
     
 */
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // print("-in didSelectItemAtIndexPath-")
        
        /*
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
 
 */
    }
    

    
}
