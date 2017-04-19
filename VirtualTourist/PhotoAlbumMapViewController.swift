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
    
    var album : Album?
    var flickrImages = [FlickrImage]()
    var imagesFoundCount = 0
    var flickrAlbumPage = 1
    var selectedIndexes = Set<Int>()
    var selectedImagesToBeDeleted = 0
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("in PhotoAlbumViewController")
        
        print("latitude of album found: \(album?.latitude)")
        print("longitude of album found: \(album?.longitude)")
        
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

    }
    
    func loadImages(){
        
        print(#function)
        //initialize the cells to show activity indicator
        /*
        if let size = Int(FlickrConstants.FlickrParameterValues.Limit){
            
            for _ in 0..<size{
                //   let x = FlickrImage()
                //   flickrImages.append(x)
            }
        }*/
        
        if album != nil {
            
            if let imageCount = album?.images?.count {
                
                if imageCount > 0 {
                    
                    print("A collection of images already exists for this album")
                    showImagesFromAlbum()
                    
                }else{
                    
                    getCollection(page: 1)

                }
                
            }
            
            
        }
        
        
        
    }
    
    func showImagesFromAlbum(){
    
        print(#function)
        
        self.flickrImages = album?.images!.allObjects as! [FlickrImage]
        
        self.collectionView.reloadData()
        
        self.newCollectionButton.isEnabled = true
        
        
    }
    
    
    func saveLoadedImage(flickrImage : FlickrImage, image: UIImage){
        
        // create NSData from UIImage
        guard let imageData = UIImageJPEGRepresentation(image, 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        flickrImage.imageData = imageData as NSData?
        
    }
    
    
    func initLocation(){
        
        if let currentAlbum = album {

            print("currentAlbum.latitude \(currentAlbum.latitude)")
            print("currentAlbum.longitude \(currentAlbum.longitude)")
            
            
            let coordinate = CLLocationCoordinate2D(latitude: Double(currentAlbum.latitude), longitude: Double(currentAlbum.longitude))
            
            
            let mapSpanLat : Double = 1
            let mapSpanLon : Double  = 1
            
            //zoom the map to the selected location
            let span = MKCoordinateSpanMake(mapSpanLat, mapSpanLon)
            
            let region = MKCoordinateRegionMake(coordinate, span)
            self.mapVIew.setRegion(region, animated: false)
            
            showAlbum(album: currentAlbum)
        }
    }
    
    
    func showAlbum(album : Album){
        
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: Double(album.latitude), longitude: Double(album.longitude))
        
        print("album.latitude:\(album.latitude)")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        
        
        // When the array is complete, we add the annotations to the map.
        self.mapVIew.addAnnotations(annotations)
        
    }
    
    
    // Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return flickrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(#function)
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        
        
        cell.initCell()
        
        
        let flickrImage = self.flickrImages[indexPath.row]
        
        if flickrImage.imageData != nil {

            print("image exists")
            //get image from object
            cell.locationImage.image = UIImage(data: flickrImage.imageData as! Data)
            flickrImageDidLoad(cell)
        
        }else if let imageUrlString = flickrImage.url{
            
            print("download image")
            
            // if an image exists at the url, set the image and title
            let imageURL = URL(string: imageUrlString)
            
            getDataFromUrl(url: imageURL!){ data, response, error in
                
                if error == nil{
                    
                    performUIUpdatesOnMain {
                        cell.locationImage.image = UIImage(data: data!)
                        
                        //save the loaded image
                        self.saveLoadedImage(flickrImage: flickrImage, image:  cell.locationImage.image!)
                        
                        self.flickrImageDidLoad(cell)
                    }
                }
                
            }
        }
        
        return cell
    }
    
    func flickrImageDidLoad(_ cell : PhotoCollectionViewCell){
    
        cell.activityIndicator.stopAnimating()
        self.imagesFoundCount = self.imagesFoundCount - 1
        
        //If all images have been loaded, eneable the
        //new collection button
        if self.imagesFoundCount == 0 {
            self.newCollectionButton.isEnabled = true
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(#function)
        
        if let cell = collectionView.cellForItem(at: indexPath){

            
            flickrImages[indexPath.row].deleteSw = !flickrImages[indexPath.row].deleteSw
            
            
            if flickrImages[indexPath.row].deleteSw {
                
                cell.alpha = 0.5
                selectedImagesToBeDeleted = selectedImagesToBeDeleted + 1
                
            }else{
                cell.alpha = 1.0
                selectedImagesToBeDeleted = selectedImagesToBeDeleted - 1
            }
            
            if selectedImagesToBeDeleted > 0 {
                
                newCollectionButton.title = "Remove Selected Pictures"
            }else{
                newCollectionButton.title = "New Collection"
            }
    
                   }
    }
    
    
    @IBAction func getNewCollection(_ sender: Any) {
        
        print(#function)
        
        if newCollectionButton.title == "New Collection"{
        
            album?.images = nil
            flickrAlbumPage = flickrAlbumPage + 1
            getCollection(page: flickrAlbumPage)
        }else{
            //delete selected images
            
            print("in delete")
            
            flickrImages = flickrImages.filter{
                (flickImage : FlickrImage) -> Bool in
                return !flickImage.deleteSw
            }
            
            album?.images  = Set(flickrImages) as NSSet?
            

            self.collectionView?.reloadData()
            
            newCollectionButton.title = "New Collection"
            saveContext()
        
        }
        
        
    }
    
    func saveContext(){
    
        
        print(#function)
        
        do {
            try CoreDataStack.sharedInstance().saveContext()
        } catch {
            print("Error while saving.")
        }
        
    }
    
    func getCollection(page : Int){
        
        
        print(#function)
        
        
        let stack =  CoreDataStack.sharedInstance()
        
        let mapLatitude  = album?.latitude
        let mapLongitude = album?.longitude
        
        var location = [String : Any]()
        
        // let mapLatitude = String(format:"%.2f", mapLatitudeDegrees!)
        //let mapLongitude = String(format:"%.2f", mapLongitudeDegrees!)
        
        
        location[VTMap.Location.Latitude] =  mapLatitude
        location[VTMap.Location.Longitude] = mapLongitude
        
        
        FlickrClient.sharedInstance().getFlickImagesByLocation(album: album!, page: page, context: stack.context){ success, flickrImages, error in
            
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
                print("images count : \(flickrImages?.count)")

                
            }else{
                print("error>")
                //self.noImagesFoundView.isHidden = false
                // self.showErrorAlert("Error in Logout")
            }
            
            
            //    }
            
            
            
        }
        
    }
    
}
