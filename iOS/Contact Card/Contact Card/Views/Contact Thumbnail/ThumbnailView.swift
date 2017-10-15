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
    
    private let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let nameLabel = UILabel()
    var availableWidth:CGFloat = 59.5
    var customBorderColor:UIColor?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.availableWidth/2
        self.layer.masksToBounds = true
        
        if let borderColor = self.customBorderColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
        }
        
        self.nameLabel.textAlignment = .center
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont(name: "Nunito-Regular", size: 27)
        
        let startColor = UIColor.init(red: 167.0/255.0, green: 172.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor as CGColor
        let endColor = UIColor.init(red: 132.0/255.0, green: 136.0/255.0, blue: 147.0/255.0, alpha: 1.0).cgColor as CGColor
        
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.locations = [0.0, 1.0]
        
        self.layer.addSublayer(gradientLayer)
        self.addSubviewWithOccupyingConstraints(subView: nameLabel)
        self.addSubviewWithOccupyingConstraints(subView: imageView)
    }

    weak var contact:CNContact! {
        didSet {
            var thumbnailText = ""
            
            if !isEmpty(self.contact.givenName) {
                let index = self.contact.givenName.index(self.contact.givenName.startIndex, offsetBy: 1)
                thumbnailText += self.contact.givenName.substring(to: index).capitalized
            }
            
            if !isEmpty(self.contact.familyName) {
                let index = self.contact.familyName.index(self.contact.familyName.startIndex, offsetBy: 1)
                thumbnailText += self.contact.familyName.substring(to: index).capitalized
            }
            
            self.nameLabel.text = thumbnailText
            if let imageData = self.contact.thumbnailImageData,
                let image =  UIImage(data: imageData) {
                self.imageView.image = image
            } else {
                self.imageView.image = nil
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
