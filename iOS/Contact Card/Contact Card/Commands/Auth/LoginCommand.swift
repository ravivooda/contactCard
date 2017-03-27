//
//  LoginCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import SSKeychain

class LoginCommand: Command {
    
    class User {
        static let service = "CCService"
        let id:Int
        let email:String
        let password:String
        
        init(id:Int, email:String, password:String) {
            self.id = id
            self.email = email
            self.password = password
        }
    }
    
    static var user:User?
    
    let returnCommand:Command?
    let loginViewController:LoginViewController
    
    init(viewController:UIViewController, returnCommand:Command?) {
        self.returnCommand = returnCommand
        if viewController is LoadingViewController {
            loginViewController = viewController as! LoginViewController
            loginViewController.loginTextField.text = ""
            loginViewController.passwordTextField.text = ""
        } else {
            loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        }
        super.init(viewController: viewController)
    }
    
    override func execute() {
        loginViewController.loginCommand = self
        
        if presentingViewController is LoginViewController {
            self.login()
        } else {
            self.presentingViewController.present(loginViewController, animated: true) {
                self.login()
            }
        }
    }
    
    func login() -> Void {
        if let accounts = SSKeychain.accounts(forService: User.service) {
            for account in accounts {
                if let username = account["acct"] as? String, let password = SSKeychain.password(forService: User.service, account: username) {
                    self.loginViewController.loginTextField.text = username
                    self.loginViewController.passwordTextField.text = password
                    self.loginViewController.loginClicked(self.loginViewController.loginButton)
                }
            }
        }
    }
    
    func loginCompleted(user:User) -> Void {
        // Register for notifications
        AppDelegate.registerForRemoteNotifications()
        
        LoginCommand.user = user
        SSKeychain.setPassword(user.password, forService: User.service, account: user.email)
        
        if !UserDefaults.standard.bool(forKey: "user_toggle") {
            self.logout()
            return;
        }
        
        self.presentingViewController.dismiss(animated: true) {
            self.returnCommand?.execute()
        }
    }
    
    
    private func logout() -> Void {
        LogoutCommand(viewController: loginViewController).execute()
    }
}
