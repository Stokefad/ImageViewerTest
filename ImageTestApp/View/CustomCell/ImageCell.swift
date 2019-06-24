//
//  ImageCell.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    let cellImageView = UIImageView()
    let authorLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureUI(imageModel : ImageModel) {
        
        self.backgroundColor = UIColor.white
        
        guard let image = imageModel.image else {
            return
        }
        
        let imageViewHeight = ImageSizer.sizeImageViewHeight(model: imageModel, view: self)
        
        cellImageView.frame = CGRect(x: 15, y: 15, width: Double(self.frame.width - 30), height: imageViewHeight)
        cellImageView.image = image
        
        authorLabel.font = UIFont.systemFont(ofSize: 24)
        authorLabel.textColor = UIColor.black
        authorLabel.frame.origin = CGPoint(x: 30, y: imageViewHeight + 35)
        authorLabel.frame.size = CGSize(width: 5000, height: 1000)
        authorLabel.text = imageModel.author
        authorLabel.sizeToFit()
        
        if cellImageView.superview == nil, authorLabel.superview == nil {
            self.addSubview(cellImageView)
            self.addSubview(authorLabel)
        }
    
    }
    
}
