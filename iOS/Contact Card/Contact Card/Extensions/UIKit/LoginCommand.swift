//
//  LoginCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class LoginCommand: Command {
    
    class User {
        
    }
    
    let returnCommand:Command?
    let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    
    init(viewController:UIViewController, returnCommand:Command?) {
        self.returnCommand = returnCommand
        super.init(viewController: viewController)
    }
    
    override func execute() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loginCommand = self
        loginViewController.loginCommand = self
        self.presentingViewController.present(loginViewController, animated: true, completion: nil)
    }
    
    func loginCompleted(user:User) -> Void {
        self.presentingViewController.dismiss(animated: true) { 
            self.returnCommand?.execute()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.loginCommand = nil
        }
    }
}
