//
//  ThumbnailView.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/30/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Contacts

class ThumbnailView: UIView {
    
    private let imageView:UIImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubviewWithOccupyingConstraints(subView: imageView)
        
        self.layer.cornerRadius = 45
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }

    var contact:CNContact! {
        didSet {
            if let imageData = self.contact.thumbnailImageData,
                let image =  UIImage(data: imageData) {
                self.imageView.image = image
            } else {
                self.imageView.image = nil
            }
        }
    }
}
