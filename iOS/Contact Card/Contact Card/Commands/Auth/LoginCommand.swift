//
//  LoginCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class LoginCommand: Command {
    static let AuthenticationChangedNotificationKey = NSNotification.Name(rawValue: "LoginCommand.AuthChanged")
    
    class User {
        static let service = "CCService"
        let id:String
        
        init(id:String) {
            self.id = id
        }
    }
    
    static var user:User?
    
    init(viewController:UIViewController, returnCommand:Command?) {
        super.init(viewController: viewController, returningCommand: returnCommand)
        LoginViewController.loginCommand = self;
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        LoginCommand.user = nil
        print("Trying to logging in")
        Manager.contactsContainer.fetchUserRecordID { (recordID, error) in
            if error != nil || isEmpty(recordID?.recordName) {
                print("Login error: \(error?.localizedDescription ?? "")")
                DispatchQueue.main.async {
                    if self.presentingViewController.presentedViewController == nil {
                        let loginViewController = self.presentingViewController as? LoginViewController ?? LoginViewController(nibName: "LoginViewController", bundle: nil)
                        self.presentingViewController.present(loginViewController, animated: true, completion: nil)
                    } else {
                        print("Not showing controller again")
                    }
                }
            } else {
                print("Logged in as user: \(recordID!.recordName)")
                
                DispatchQueue.main.async {
                    // Register for notifications
                    AppDelegate.registerForRemoteNotifications()
                }
                LoginCommand.user = User(id: recordID!.recordName)
                self.finished()
            }
        }
    }
    
    override func finished() {
        LoginViewController.loginCommand = nil;
        DispatchQueue.main.async {
            self.presentingViewController.dismiss(animated: true) {
                
            }
            
            if let _ = LoginCommand.user {
                NotificationCenter.contactCenter.post(name: LoginCommand.AuthenticationChangedNotificationKey, object: nil)
            }
            super.finished()
        }
    }
}
