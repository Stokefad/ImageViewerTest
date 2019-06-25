//
//  ImageViewModel.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RealmSwift


class ImageVM {
    
    let queue = DispatchQueue(label: "queue.imageDownloader")
    
    public static let shared = ImageVM()
    
    public var imagesRelay = BehaviorRelay(value: [ImageModel]())
    public var networkRelay = BehaviorRelay(value: Bool())
    public var successRelay = BehaviorRelay(value: Bool())
    
    fileprivate var images = [ImageModel]()
    
    let realm = try! Realm()
    
    public func startImageFetching() {
        
        var responseImageList = [ImageModel]()
           queue.async {
            Alamofire.request(IMAGES_URL, method: .get).responseJSON { [unowned self] response in
                
                switch response.result {
                case .failure(let error):
                    self.retriveImagesFromCache()
                    print("No connection - \(error.localizedDescription)")
                    self.networkRelay.accept(false)
                    self.successRelay.accept(true)
                    return
                case .success(_):
                    print("Success")
                    self.networkRelay.accept(true)
                    self.successRelay.accept(true)
                }
                
                guard let data = response.result.value as? [Dictionary<String, Any>] else {
                    return
                }
        
                for item in data {
                    responseImageList.append(ImageModel(json: item))
                }
                
                for image in responseImageList {
                    self.donwloadImage(imageModel: image)
                }
            }
        }
        
    }
    
    fileprivate func retriveImagesFromCache() {
        
        let result = realm.objects(RealmImageModel.self)
        
        if result.count == 0 {
            successRelay.accept(false)
            return
        }

        for image in result {
            let model = ImageModel(image: image)
            images.append(model)
        }
        imagesRelay.accept(images)
    }
    
    fileprivate func donwloadImage(imageModel : ImageModel) {
        
        DispatchQueue(label: "queue.backgroundDownloading").async {
            Alamofire.request(imageModel.downloadURL, method: .get).responseData { (data) in
                //  print("\(imageModel.downloadURL) - url")
                guard let data = data.data else {
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    return
                }
                
                imageModel.image = image.resizeImageWith(ratio: UIScreen.main.bounds.size.width / image.size.width * 0.5)
                
                imageModel.dateDownloaded = Date()
                
                ImageVM.shared.images.append(imageModel)
                
                ImageVM.shared.imagesRelay.accept(ImageVM.shared.images)
                
                if ImageVM.shared.images.count == 1 {
                    ImageVM.shared.deletePreviousImages()
                }
                
                ImageVM.shared.cacheNewImage(image: imageModel)
                
                print(ImageVM.shared.images.count)
                
            }
        }

    }
    
    
    fileprivate func cacheNewImage(image : ImageModel) {
        DispatchQueue(label: "queue.backgroundlocal").async {
            autoreleasepool {
                
                let realm = try! Realm()
                
                let imageItem = RealmImageModel()
                if let image = image.image {
                    if let data = image.jpegData(compressionQuality: 0.3) {
                        imageItem.image = data
                    }
                }
                imageItem.author = image.author
                imageItem.downloadDate = image.dateDownloaded
                imageItem.height = Int(image.size.height)
                imageItem.width = Int(image.size.width)
                
                try! realm.write {
                    realm.add(imageItem)
                }
                
            }
        }
        
    }
    
    fileprivate func deletePreviousImages() {
        let result = realm.objects(RealmImageModel.self)
        
        try! realm.write {
            realm.delete(result)
        }
        
    }
    
}
