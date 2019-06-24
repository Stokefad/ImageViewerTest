//
//  FullScreenView.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class FullScreenView: UIView {
    
    var sender : UIViewController?

    convenience init(sender : UIViewController, imageModel : ImageModel) {
        self.init(frame: CGRect(x: 0, y: 0, width: sender.view.frame.width, height: sender.view.frame.height))
        self.sender = sender
        configureUI(imageModel: imageModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func removeView() {
        self.removeFromSuperview()
        guard let sender = sender else {
            return
        }
        UIView.transition(with: sender.view, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    private func configureUI(imageModel : ImageModel) {
        self.backgroundColor = UIColor.black
        
        let imageView = UIImageView()
        let dateLabel = UILabel()
        let exitButton = UIButton()
        
        guard let image = imageModel.image else {
            return
        }
        
        let imageViewHeight = ImageSizer.sizeImageViewHeight(model: imageModel, view: self)
        
        imageView.frame = CGRect(x: 15, y: (Double(self.frame.height) - imageViewHeight) / 2, width: Double(self.frame.width - 30), height: imageViewHeight)
        imageView.image = image
        
        exitButton.frame = CGRect(x: 20, y: 50, width: 40, height: 40)
        exitButton.backgroundColor = UIColor.white
        exitButton.addTarget(self, action: #selector(removeView), for: .touchUpInside)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dateStr = formatter.string(from: imageModel.dateDownloaded)
        
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = UIColor.white
        dateLabel.frame.size = CGSize(width: 5000, height: 1000)
        dateLabel.text = "Дата скачивания - \(dateStr)"
        dateLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: (self.frame.width - dateLabel.frame.width) / 2, y: imageView.frame.origin.y + imageView.frame.height + dateLabel.frame.height + 15)
        
        if imageView.superview == nil, dateLabel.superview == nil, exitButton.superview == nil {
            self.addSubview(imageView)
            self.addSubview(dateLabel)
            self.addSubview(exitButton)
        }
    }
    
}

class FullScreenFactory {
    public static func returnFullScreen(imageModel : ImageModel, sender : UIViewController) -> UIView {
        return FullScreenView(sender: sender, imageModel: imageModel)
    }
}
