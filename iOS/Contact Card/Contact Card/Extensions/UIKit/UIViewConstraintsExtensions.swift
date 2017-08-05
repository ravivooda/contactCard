//
//  UIViewConstraintsExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/27/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewWithOccupyingConstraints(subView:UIView) -> Void {
        self.addSubview(subView)
        subView.setupToOccupyView(parentView: self)
    }
    
    func setupToOccupyView(parentView:UIView) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
    }
}
