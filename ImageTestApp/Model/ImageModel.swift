//
//  ImageModel.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import Foundation
import UIKit


class ImageModel {
    
    init(json : Dictionary<String, Any>) {
        guard let author = json["author"], let id = json["id"], let height = json["height"], let width = json["width"], let url = json["download_url"] else {
            return
        }
        
        guard id as? String != nil, author as? String != nil, height as? Int != nil, width as? Int != nil, url as? String != nil else {
            print("prob")
            return
        }
        
        self.author = author as! String
        self.id = id as! String
        self.downloadURL = url as! String
        self.size.height = CGFloat(height as! Int)
        self.size.width = CGFloat(width as! Int)
        
    }
    
    var id : String = String()
    var author : String = ""
    
    var size : CGSize = CGSize()
    
    var downloadURL : String = String()
    
    var image : UIImage?
    
    var dateDownloaded = Date()
    
}
