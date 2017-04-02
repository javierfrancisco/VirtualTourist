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
import CoreData

class PhotoAlbumMapViewController:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mapVIew: MKMapView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    @IBOutlet weak var noImagesFoundView: UIView!
    var selectedLocation : MKAnnotation?
    
    var flickrImages = [FlickrImage]()
    var imagesFoundCount = 0
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        print("in PhotoAlbumViewController")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        noImagesFoundView.isHidden = true
        newCollectionButton.isEnabled = false
        
        initLocation()
        
        loadImages()
        
        
        let space: CGFloat = 0.0
        
        let dimension =  (self.view.frame.size.width - (2 * space)) / 3.0
        
        collectionFlowLayout.minimumInteritemSpacing = space
        collectionFlowLayout.minimumLineSpacing = space
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
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
        
        
        
    }
    
    func loadImages(){
        
        
        //initialize the cells to show activity indicator
        if let size = Int(FlickrConstants.FlickrParameterValues.Limit){
        
            for _ in 0..<size{
                let x = FlickrImage()
                flickrImages.append(x)
            }
        }
        
        
        
        
        if selectedLocation != nil {
            
            let mapLatitudeDegrees  = selectedLocation?.coordinate.latitude
            let mapLongitudeDegrees = selectedLocation?.coordinate.longitude
            
            var location = [String : Any]()
            
            let mapLatitude = String(format:"%.2f", mapLatitudeDegrees!)
            let mapLongitude = String(format:"%.2f", mapLongitudeDegrees!)
            
       
            location[VTMap.Location.Latitude] =  mapLatitude
            location[VTMap.Location.Longitude] = mapLongitude
            
            
            FlickrClient.sharedInstance().getFlickImagesByLocation(location: location as [String : AnyObject]){ success, flickrImages, error in
                
             //   performUIUpdatesOnMain {
                    
                    
                    if success{
                        print("success>")
                        self.flickrImages = flickrImages!
                        performUIUpdatesOnMain {
                            self.collectionView.reloadData()
                        }
                        
                        self.imagesFoundCount = (flickrImages?.count)!
                        
                        if self.imagesFoundCount == 0 {
                        
                            self.noImagesFoundView.isHidden = false
                        }
                        
                        print("getFlickImagesByLocation call completed>")
                        print("images count : \(flickrImages)")
                        
                       // for flickr in flickrImages! {
                         //   print("url:\(flickr.urlM)")
                       // }
                        
                        self.saveNewLocation(location: location, images: flickrImages!)
                        
                        
                        
                    }else{
                        print("error>")
                        //self.noImagesFoundView.isHidden = false
                       // self.showErrorAlert("Error in Logout")
                    }
                    
                    
            //    }
                
                
                
            }
            
        }
        
        
        
    }
    
    func saveNewLocation(location: [String : Any], images : [FlickrImage] ){
    
        let album = Album(location: location, context: fetchedResultsController!.managedObjectContext)
        
         print("Just created a album: \(album)")
         print("Sections found: \(fetchedResultsController.sections?.count)")
        
        
        
        for flickrImage in images {
            
            
            let image = Image(flickrImage: flickrImage, context: fetchedResultsController!.managedObjectContext)
            
            print("Just created a image: \(image)")
            
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // print("number of memes: \(memes.count)")
        // return memes.count
        return flickrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("-in cellForItemAtIndexPath-")
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        
    
        cell.initCell()
       
        
        let flickrImage = self.flickrImages[indexPath.row]
        
        if let imageUrlString = flickrImage.urlM{
        
            // if an image exists at the url, set the image and title
            let imageURL = URL(string: imageUrlString)
            
            getDataFromUrl(url: imageURL!){ data, response, error in
                
                if error == nil{
                    
                    performUIUpdatesOnMain {
                        cell.locationImage.image = UIImage(data: data!)
                        cell.activityIndicator.stopAnimating()
                        
                        self.imagesFoundCount = self.imagesFoundCount - 1
                        
                        //If all images have been loaded, eneable the
                        //new collection button
                        if self.imagesFoundCount == 0 {
                            self.newCollectionButton.isEnabled = true
                        }
                    }
                }
                
            }
         }
        
        
        return cell
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // print("-in didSelectItemAtIndexPath-")
        
        /*
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
         
         detailController.meme = self.memes[indexPath.row]
         self.navigationController!.pushViewController(detailController, animated: true)
         
         */
    }
    
    
    @IBAction func getNewCollection(_ sender: Any) {
        
        print(#function)
    }
    
}
