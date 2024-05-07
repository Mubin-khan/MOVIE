//
//  UIIamageView+Extension.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/7/24.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension String{
    func cacheImage(completion : @escaping(_ img : UIImage?) -> ()){
    let url = URL(string: self)
    
    if let imageFromCache = imageCache.object(forKey: self as AnyObject) as? UIImage {
        completion(imageFromCache)
        return
    }
        
    URLSession.shared.dataTask(with: url!) {
        data, response, error in
          if let response = data {
              DispatchQueue.main.async {
                  if let imageToCache = UIImage(data: response) {
                      imageCache.setObject(imageToCache, forKey: self as AnyObject)
                      completion(imageToCache)
                  }else {
                      completion(nil)
                  }
              }
          }else {
              completion(nil)
          }
     }.resume()
  }
}

