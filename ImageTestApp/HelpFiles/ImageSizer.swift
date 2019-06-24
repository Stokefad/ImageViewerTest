//
//  ImageSizer.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit


class ImageSizer {
    
    public static func sizeImageViewHeight(model : ImageModel, view : UIView) -> Double {
        let ratio = model.size.height / model.size.width
        
        return Double(view.frame.width * ratio)
    }
    
}
