 //
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import UIKit
import Foundation
import CoreData

// MARK: - TMDBClient (Convenient Resource Methods)

extension FlickrClient {
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    func getFlickImagesByLocation(album : Album, page : Int, context: NSManagedObjectContext, completionHandlerForImages: @escaping (_ success : Bool, _ flickrImages : [FlickrImage]?, _ errorString:  String? ) -> Void){
        
        
        getPhotoAlbumByLocation(album : album, pageNum: page, context : context){
            success, flickrImages, error in
            
            
            if success {
        
                completionHandlerForImages(true, flickrImages, nil)
                
            }else{
                
                
                completionHandlerForImages(false, nil, "No Images Found")
            }
            
        }
        
    }
    
    

    func getPhotoAlbumByLocation(album: Album, pageNum : Int, context: NSManagedObjectContext,  completionHandlerForAlbum: @escaping (_ sucess: Bool, _ flickrImages : [FlickrImage]?,   _ errorString: String?) -> Void){
        
        let latitude = String(album.latitude)
        let longitude = String(album.longitude)
        
        var page = "1"//by default page is 1
        if pageNum != 0 {
            page = String(pageNum)
        }
        
        /* 1. Set the parameters */
        
        let methodParameters = [
            FlickrConstants.FlickrParameterKeys.Method: FlickrConstants.FlickrParameterValues.GalleryPhotosSearchMethod,
            FlickrConstants.FlickrParameterKeys.APIKey: FlickrConstants.FlickrParameterValues.APIKey,
            FlickrConstants.FlickrParameterKeys.Extras: FlickrConstants.FlickrParameterValues.MediumURL,
            FlickrConstants.FlickrParameterKeys.Format: FlickrConstants.FlickrParameterValues.ResponseFormat,
            FlickrConstants.FlickrParameterKeys.Limit: FlickrConstants.FlickrParameterValues.Limit,
            FlickrConstants.FlickrParameterKeys.Page: page,
            FlickrConstants.FlickrParameterKeys.NoJSONCallback: FlickrConstants.FlickrParameterValues.DisableJSONCallback, FlickrConstants.FlickrParameterKeys.Latitude : latitude, FlickrConstants.FlickrParameterKeys.Longitude : longitude, FlickrConstants.FlickrParameterKeys.Radius : FlickrConstants.FlickrParameterValues.Radius
            
        ]

        
       
        /* 2. Make the request */
        
        
        let task = FlickrClient.sharedInstance().taskForGETMethod(FlickrConstants.FlickrParameterValues.GalleryPhotosSearchMethod, parameters: methodParameters as [String : AnyObject] ){
        
            (results, error) in
            
            
            func displayError(_ error: String){
                
                print(error)
                completionHandlerForAlbum(false, nil, "No images found")
            }
            
            if error != nil {
                
                displayError("Response returned an error")
            }
            
             
            guard let results = results else {
                
                displayError("Cannot find 'results' in Response")
                return
            }
            
           
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = results[FlickrConstants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[FlickrConstants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                
                    displayError("Cannot find 'photo' in Response")
                return
            }
            
            
            
            var flickrImages = [FlickrImage]()
            
            for photoArrayDictionary in photoArray {
                
                
                let flickrImage : FlickrImage = FlickrImage(dictionary: photoArrayDictionary, album: album , context : context)
                
                flickrImages.append(flickrImage)
            }
            
            
            completionHandlerForAlbum(true, flickrImages, nil)
            
      
            }

                    
        }
        
    

}
