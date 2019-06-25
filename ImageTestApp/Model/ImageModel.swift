//
//  ImageModel.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class ImageModel {
    
    init(json : Dictionary<String, Any>) {
        guard let author = json["author"], let id = json["id"], let height = json["height"], let width = json["width"], let url = json["download_url"] else {
            return
        }
        
        guard id as? String != nil, author as? String != nil, height as? Int != nil, width as? Int != nil, url as? String != nil else {
            return
        }
        
        self.author = author as! String
        self.id = id as! String
        self.downloadURL = url as! String
        self.size.height = CGFloat(height as! Int)
        self.size.width = CGFloat(width as! Int)
        
    }
    
    init(image : RealmImageModel) {

        self.author = image.author
        self.dateDownloaded = image.downloadDate
        self.size.height = CGFloat(image.height)
        self.size.width = CGFloat(image.width)
        self.image = UIImage(data: image.image)
    }
    
    var id : String = String()
    var author : String = ""
    
    var size : CGSize = CGSize()
    
    var downloadURL : String = String()
    
    var image : UIImage?
    
    var dateDownloaded = Date()
    
}


class RealmImageModel : Object {
    
    @objc dynamic var downloadURL : String = String()
    @objc dynamic var image = Data()
    @objc dynamic var author = String()
    @objc dynamic var height = Int()
    @objc dynamic var width = Int()
    @objc dynamic var downloadDate = Date()
    
}
