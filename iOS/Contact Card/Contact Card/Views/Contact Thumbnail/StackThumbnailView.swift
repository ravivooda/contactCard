//
//  StackThumbnailView.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/6/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class StackThumbnailView: UIView {
    let thumbNail1 = ThumbnailView()
    let thumbNail2 = ThumbnailView()
    let thumbNail3 = ThumbnailView()
    
    let thumbnailStackSeparatorWidthInset:CGFloat = 10.0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumbnailBorderColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        thumbNail1.customBorderColor = thumbnailBorderColor
        thumbNail1.awakeFromNib()
        thumbNail2.customBorderColor = thumbnailBorderColor
        thumbNail2.awakeFromNib()
        thumbNail3.customBorderColor = thumbnailBorderColor
        thumbNail3.awakeFromNib()
        self.add(thumbnailImage: thumbNail1, atPosition: 1)
        self.add(thumbnailImage: thumbNail2, atPosition: 2)
        self.add(thumbnailImage: thumbNail3, atPosition: 3)
    }
    
    var newContacts:[AddContactCardCommand]! {
        didSet {
            thumbNail1.contact = self.newContacts[0].generateContactReference()
            
            if self.newContacts.count >= 2 {
                self.thumbNail2.contact = self.newContacts[1].generateContactReference()
            }
            
            self.thumbNail2.alpha = self.newContacts.count >= 2 ? 1 : 0
            
            if self.newContacts.count >= 3 {
                self.thumbNail3.contact = self.newContacts[2].generateContactReference()
            }
            
            self.thumbNail3.alpha = self.newContacts.count >= 3 ? 1 : 0
            
            self.updateWidthConstraint(forThumbnailCount: max(3, self.newContacts.count))
        }
    }
    
    private func add(thumbnailImage:ThumbnailView, atPosition position:Int) -> Void {
        if thumbnailImage.superview != nil {
            return
        }
        
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumbnailImage)
        NSLayoutConstraint(item: thumbnailImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: thumbnailImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: CGFloat(position - 1) * thumbnailStackSeparatorWidthInset).isActive = true
        NSLayoutConstraint(item: thumbnailImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: thumbnailImage, attribute: .width, relatedBy: .equal, toItem: thumbnailImage, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    
    private func updateWidthConstraint(forThumbnailCount count:Int) {
        for constraint in self.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 90 + CGFloat(count - 1) * thumbnailStackSeparatorWidthInset
            }
        }
    }
}
