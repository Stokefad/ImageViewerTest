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
    let dateLabel = UILabel()

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
        
        let imageViewHeight = ImageSizer.sizeImageViewHeight(model: imageModel, view: self)
        
        cellImageView.frame = CGRect(x: 15, y: 15, width: Double(self.frame.width - 30), height: imageViewHeight)
        
        if let image = imageModel.image {
            DispatchQueue.main.async {
                self.cellImageView.image = image
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dateStr = formatter.string(from: imageModel.dateDownloaded)
        
        authorLabel.font = UIFont.systemFont(ofSize: 24)
        authorLabel.textColor = UIColor.black
        authorLabel.frame.origin = CGPoint(x: 30, y: imageViewHeight + 35)
        authorLabel.frame.size = CGSize(width: 5000, height: 1000)
        authorLabel.text = imageModel.author
        authorLabel.sizeToFit()
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = UIColor.gray
        dateLabel.frame.size = CGSize(width: 5000, height: 1000)
        dateLabel.text = dateStr
        dateLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: self.frame.width - dateLabel.frame.width - 30, y: CGFloat(imageViewHeight + 35 + Double(authorLabel.frame.height) + 10))
        
        if cellImageView.superview == nil, authorLabel.superview == nil, dateLabel.superview == nil {
            self.addSubview(cellImageView)
            self.addSubview(authorLabel)
            self.addSubview(dateLabel)
        }
        
    }
    
}
