//
//  LoginViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/8/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginInputContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    static var loginCommand:LoginCommand? = nil
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    func addSubViewWithConstraints(textField:TextField, belowView:TextField?, inView:UIView) {
        inView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        if belowView != nil {
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: belowView, attribute: .bottom, multiplier: 1.0, constant: 10).isActive = true
        } else {
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: inView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        }
        NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: loginInputContainer, attribute: .leading, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: loginInputContainer, attribute: .trailing, multiplier: 1.0, constant: -10).isActive = true
        NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0).isActive = true
    }
}
