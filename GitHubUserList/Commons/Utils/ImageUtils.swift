//
//  ImageUtils.swift
//  GitHubUserList
//
//  Created by Teeramet Kanchanapiroj on 25/3/2564 BE.
//

import Foundation
import Kingfisher
import UIKit

class ImageUtils {
    
    static func loadImage(_ imageView :UIImageView,_ path : String?){
        loadImage(imageView, path, nil)
    }
    
    static func loadImage(_ imageView :UIImageView,_ path : String? , _ complete : (()->Void)?){
        guard let url = URL.init(string: path ?? "") else{
            imageView.image = UIImage(named: "ic_default_image")
            complete?()
            return
        }
        _ = imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageUrl) in
            complete?()
            if let image = image{
                imageView.image = image
            }else{
                imageView.image = UIImage(named: "ic_default_image")
            }
        })
    }
}
