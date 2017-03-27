//
//  LogoutCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 3/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class LogoutCommand: Command {
    
    let loginViewController:LoginViewController
    
    override init(viewController:UIViewController) {
        if viewController is LoginViewController {
            loginViewController = viewController as! LoginViewController
        } else {
            loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        }
        super.init(viewController: viewController)
    }
    
    override func execute() {
        if AppDelegate.deviceToken == nil {
            AppDelegate.registerDevicePostCommand = self
            return
        }
        AppDelegate.registerDevicePostCommand = nil
        LoginCommand.user = nil
        if presentingViewController is LoginViewController {
            self.logout()
        } else {
            self.presentingViewController.present(loginViewController, animated: true, completion: { 
                self.logout()
            })
        }
    }
    
    private func logout() -> Void {
        loginViewController.loginTextField.text = ""
        loginViewController.passwordTextField.text = ""
        Data.logout(callingViewController: loginViewController, success: { (response) in
            print("Successfully logged out user \(LoginCommand.user)")
            UserDefaults.standard.set(true, forKey: "user_toggle")
        }) { (response, httpResponse) in
            print("Failed in logging out the user with response \(httpResponse)")
        }
    }

}
