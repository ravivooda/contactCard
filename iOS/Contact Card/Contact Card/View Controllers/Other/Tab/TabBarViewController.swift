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
        // LoginCommand(viewController: self, returnCommand: nil).execute()
    }
}
