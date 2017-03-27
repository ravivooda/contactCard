//
//  LogoutCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 3/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import SSKeychain

class LogoutCommand: Command {
    
    override init(viewController:UIViewController) {
        super.init(viewController: viewController)
    }
    
    override func execute() {
        if AppDelegate.deviceToken == nil {
            AppDelegate.registerDevicePostCommand = self
            return
        }
        AppDelegate.registerDevicePostCommand = nil
        self.logout()
    }
    
    private func logout() -> Void {
        Data.logout(callingViewController: presentingViewController, success: { (response) in
            print("Successfully logged out user \(LoginCommand.user)")
            
            // Reset User Defaults
            UserDefaults.standard.set(true, forKey: "user_toggle")
            
            // Remove credentials from the keychain
            if let account = LoginCommand.user?.email {
                print("Removing user credentials \(account)")
                SSKeychain.deletePassword(forService: LoginCommand.User.service, account: account)
            }
            LoginCommand.user = nil
            LoginCommand(viewController: self.presentingViewController, returnCommand: nil).execute()
        }) { (response, httpResponse) in
            print("Failed in logging out the user with response \(httpResponse)")
        }
    }

}
