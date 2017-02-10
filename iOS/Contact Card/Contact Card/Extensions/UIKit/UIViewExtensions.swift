//
//  UIViewExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/9/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Material

extension UIView {
    func addTextFields(with marginHorizontal:CGFloat, marginVertical:CGFloat, placeholders:[String]) -> [TextField] {
        var lastTextField:UIView? = self
        var textFields:[TextField] = []
        for placeHolder in placeholders {
            let textField = addTextField(placeHolder)
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: lastTextField, attribute: .top, multiplier: 1.0, constant: marginVertical).isActive = true
            NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: marginHorizontal).isActive = true
            NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -marginHorizontal).isActive = true
            NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
            
            lastTextField = textField
            textFields.append(textField)
        }
        
        return textFields
    }
    
    func addTextField(_ placeholder:String) -> TextField {
        let textField = TextField()
        
        textField.placeholder = placeholder
        textField.placeholderNormalColor = Material.Color.grey.base
        textField.font = RobotoFont.regular(with: 20)
        textField.textColor = Material.Color.black
        //textField.titleLabelAnimationDistance = 0
        
        //textField.detail = UILabel()
        //textField.titleLabel!.font =  RobotoFont.medium(with: 12)
        //textField.detailColor = Material.Color.grey.base
        textField.detailColor = Material.Color.blue.accent3
        
        let image = UIImage(named: "ic_close_white")?.withRenderingMode(.alwaysTemplate)
        
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = Material.Color.grey.base
        //clearButton.pulseScale = false
        clearButton.tintColor = Material.Color.grey.base
        clearButton.setImage(image, for: .normal)
        clearButton.setImage(image, for: .highlighted)
        
        self.addSubview(textField)
        
        return textField
    }
}
