//
//  Extensions.swift
//  accessAces
//
//  Created by Sebastian on 6/26/17.
//  Copyright © 2017 NewWave. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageWithCache(url: String){
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject){
            print("Loading cached image")
            self.image = cachedImage as! UIImage
            return
        }
        
        print("Loading image from database")
        
        let url2 = URL(string: url)
        URLSession.shared.dataTask(with: url2!, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                    
                    self.image = downloadedImage
                }
                
                
                
            }
            
        }).resume()
    }
    
}
