//
//  Command.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

typealias CommandCompleted = () -> Void

class Command: NSObject {
    
    let presentingViewController:UIViewController
    var returningCommand:Command? = nil
    var completed:CommandCompleted?
    
    init(viewController:UIViewController, returningCommand:Command?) {
        self.presentingViewController = viewController
        self.returningCommand = returningCommand
        super.init()
    }
    
    func execute(completed:CommandCompleted?) {
        self.completed = completed
    }
    
    func finished() {
        self.completed?()
        returningCommand?.execute(completed: nil)
    }
}
