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
        let id:Int
        let email:String
        let password:String
        
        init(id:Int, email:String, password:String) {
            self.id = id
            self.email = email
            self.password = password
        }
    }
    
    let returnCommand:Command?
    let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    
    init(viewController:UIViewController, returnCommand:Command?) {
        self.returnCommand = returnCommand
        super.init(viewController: viewController)
    }
    
    override func execute() {
        loginViewController.loginCommand = self
        self.presentingViewController.present(loginViewController, animated: true, completion: nil)
    }
    
    func loginCompleted(user:User) -> Void {
        self.presentingViewController.dismiss(animated: true) { 
            self.returnCommand?.execute()
        }
    }
}
