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
    
    let loginTextField = getTextField("Username")
    let passwordTextField = getTextField("Password")
    
    var loginCommand:LoginCommand? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
        loginTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
        addSubViewWithConstraints(textField: loginTextField, belowView: nil, inView: loginInputContainer)
        addSubViewWithConstraints(textField: passwordTextField, belowView: loginTextField, inView: loginInputContainer)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        Data.login(loginTextField.text!, password: passwordTextField.text!, callingViewController: self, success: { (response) in
            if let my_info = response["my_info"] as? [String: Any] {
                self.loginCommand?.loginCompleted(user: LoginCommand.User(id: getIntValue(my_info["user_id"], defaultValue: 0), email: getStringValue(self.loginTextField.text), password: getStringValue(self.passwordTextField.text)))
            }
        }) { (response, httpResponse) in
            print(response)
        }
    }
    
    
    @IBAction func signupClicked(_ sender: UIButton) {
        
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
