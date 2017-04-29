//
//  LoginCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import SSKeychain
import CloudKit

class LoginCommand: Command {
    static let AuthenticationChangedNotificationKey = "LoginCommand.AuthChanged"
    
    class User {
        static let service = "CCService"
        let id:String
        
        init(id:String) {
            self.id = id
        }
    }
    
    static var user:User?
    
    let loginViewController:LoginViewController
    
    init(viewController:UIViewController, returnCommand:Command?) {
        loginViewController = viewController as? LoginViewController ?? LoginViewController(nibName: "LoginViewController", bundle: nil)
        super.init(viewController: viewController, returningCommand: returnCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        LoginCommand.user = nil
        Manager.contactsContainer.fetchUserRecordID { (recordID, error) in
            if error != nil || isEmpty(recordID?.recordName) {
                print("Login error: \(error?.localizedDescription ?? "")")
                DispatchQueue.main.async {
                    self.presentingViewController.present(self.loginViewController, animated: true, completion: nil)
                }
            } else {
                print("Logged in as user: \(recordID!.recordName)")
                // Register for notifications
                AppDelegate.registerForRemoteNotifications()
                
                LoginCommand.user = User(id: recordID!.recordName)
                self.finished()
            }
        }
    }
    
    override func finished() {
        DispatchQueue.main.async {
            self.presentingViewController.dismiss(animated: true) {
                
            }
            if let _ = LoginCommand.user {
                NotificationCenter.contactCenter.post(name: NSNotification.Name(rawValue: LoginCommand.AuthenticationChangedNotificationKey), object: nil)
            }
            super.finished()
        }
    }
}
