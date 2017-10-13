//
//  TabBarViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let loginCommand = LoginViewController.loginCommand ?? LoginCommand(viewController: self, returnCommand: nil)
        loginCommand.execute(completed: loginCommand.completed)
        TutorialCommand(viewController: self, returningCommand: nil).execute(completed: nil)
    }
}
