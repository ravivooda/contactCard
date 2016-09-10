//
//  VersionUnsupportedCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class VersionUnsupportedCommand: Command {
    
    let appStoreURL:String
    
    
    private override init(viewController: UIViewController) {
        appStoreURL = ""
        super.init(viewController: viewController)
    }
    
    init(viewController: UIViewController, appStoreURL:String) {
        self.appStoreURL = appStoreURL
        super.init(viewController: viewController)
    }

    override func execute() {
        let controller = VersionUnsupportedViewController(nibName: "VersionUnsupportedViewController", bundle: nil)
        controller.appStoreURL = self.appStoreURL
        presentingViewController.presentViewController(controller, animated: true, completion: nil)
    }
}
