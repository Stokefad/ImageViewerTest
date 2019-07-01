//
//  LoadingView.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 01/07/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit


class LoadingView : UIView {

    var sender : UIViewController?
    
    convenience init(sender : UIViewController) {
        self.init(frame: CGRect(x: 0, y: 0, width: sender.view.frame.width, height: sender.view.frame.height))
        self.sender = sender
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}
