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
import CoreData


class ImageVM {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public static let shared = ImageVM()
    
    public var imagesRelay = BehaviorRelay(value: [ImageModel]())
    fileprivate var images = [ImageModel]()
    
    public func startImageFetching() {
        
        let queue = DispatchQueue(label: "queue.imageDownloader")
        var responseImageList = [ImageModel]()
        print("started")
        queue.async {
            Alamofire.request(IMAGES_URL, method: .get).responseJSON { response in
                
                switch response.result {
                case .failure(let error):
                    print("No connection - \(error.localizedDescription)")
                    
                case .success(_):
                    print("Success")
                }
                
                guard let data = response.result.value as? [Dictionary<String, Any>] else {
                    return
                }
        
                for item in data {
                    responseImageList.append(ImageModel(json: item))
                }
                
                for imageModel in responseImageList {
                    ImageVM.shared.donwloadImage(imageModel: imageModel)
                }
            }
        }
        
    }
    
    fileprivate func retriveImagesFromCache() {
        let fetchRequet = NSFetchRequest<Image>()
        
        do {
            
        }
        catch {
            
        }
    }
    
    fileprivate func donwloadImage(imageModel : ImageModel) {
        Alamofire.request(imageModel.downloadURL, method: .get).responseData { (data) in
          //  print("\(imageModel.downloadURL) - url")
            guard let data = data.data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            imageModel.image = image
            imageModel.dateDownloaded = Date()
            
            ImageVM.shared.images.append(imageModel)
            ImageVM.shared.cacheNewImages()
            ImageVM.shared.imagesRelay.accept(ImageVM.shared.images)
        }
    }
    
    fileprivate func cacheNewImages() {
        
        if images.count < 30 {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try ImageVM.context.execute(batchDeleteRequest)
            
        }
        catch {
            print("Unable to delete entity - Image")
        }
        
        for image in images {
            let imageItem = Image(context: ImageVM.context)
            imageItem.image = image.image
            imageItem.author = image.author
            imageItem.dateDownloaded = image.dateDownloaded
            imageItem.height = Int16(image.size.height)
            imageItem.width = Int16(image.size.width)
            
            do {
                try ImageVM.context.save()
            }
            catch {
                print("Unable to save image")
            }
        }
        
    }
    
}
