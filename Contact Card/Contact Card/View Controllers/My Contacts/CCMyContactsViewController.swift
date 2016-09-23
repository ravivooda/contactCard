//
//  CCMyContactsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class CCMyContactsViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        VersionUnsupportedCommand(viewController: self, appStoreURL: "").execute()
    }
}
