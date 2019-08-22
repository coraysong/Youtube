//
//  Extensions.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb (red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


extension UIView {
    func addConstraintsWithFormat(format:String,views:UIView...) {
        
        var viewsDictionary = [String:UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views:viewsDictionary))
    }
}


let imageCache = NSCache<AnyObject, AnyObject>()


class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = (imageFromCache as! UIImage)
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = UIImage(data: data!)
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
            
            }.resume()
    }
}
