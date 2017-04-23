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
    
    init(viewController: UIViewController, appStoreURL:String, returningCommand: Command?) {
        self.appStoreURL = appStoreURL
        super.init(viewController: viewController, returningCommand: returningCommand)
    }

    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let controller = VersionUnsupportedViewController(nibName: "VersionUnsupportedViewController", bundle: nil)
        controller.appStoreURL = self.appStoreURL
        presentingViewController.present(controller, animated: true, completion: nil)
    }
}
