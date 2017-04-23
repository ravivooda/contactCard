//
//  UIViewControllerExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Material

extension UIViewController {
    func showLoading() -> Void {
        let loadingController = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        loadingController.view.tag = 123098
        self.present(loadingController, animated: false, completion: nil)
    }
    
    func hideLoading(_ error:String?) -> Void {
        if self.presentedViewController != nil && self.presentedViewController!.view.tag == 123098 {
            self.dismiss(animated: false, completion: { 
                if !isEmpty(error) {
                    let alertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func showAlertMessage(message m:String) -> Void {
        let alertController = UIAlertController(title: "Contact Card", message: m, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}


func getTextField(_ placeholder:String) -> TextField {
    let textField: TextField = TextField()
    
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
    
    //textField.clearButton = clearButton
    
    return textField
}
