//
//  TabBarViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/10/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let loginCommand = LoginViewController.loginCommand {
            loginCommand.execute(completed: nil)
        } else if LoginCommand.user == nil {
            login(returnCommand: nil)
        }
    }
    
    func login(returnCommand:Command?) {
        LoginCommand(viewController: self, returnCommand: returnCommand).execute(completed: nil)
    }
}
