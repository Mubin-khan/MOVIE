//
//  UIIamageView+Extension.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/7/24.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String, completion : @escaping() -> ()){
    let url = URL(string: urlString)
    
    image = nil
    
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        completion()
        return
    }
        
    URLSession.shared.dataTask(with: url!) {
        data, response, error in
          if let response = data {
              DispatchQueue.main.async {
                  let imageToCache = UIImage(data: response)
                  completion()
                  imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                  self.image = imageToCache
              }
          }
     }.resume()
  }
}

