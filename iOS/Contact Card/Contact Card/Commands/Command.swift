//
//  Command.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class Command: NSObject {
    
    let presentingViewController:UIViewController
    var returningCommand:Command? = nil
    
    init(viewController:UIViewController, returningCommand:Command?) {
        self.presentingViewController = viewController
        self.returningCommand = returningCommand
        super.init()
    }
    
    func execute() {
        preconditionFailure("This method must be overridden")
    }
    
    func finished() {
        returningCommand?.execute()
    }
}
