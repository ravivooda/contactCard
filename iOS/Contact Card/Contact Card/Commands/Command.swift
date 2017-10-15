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
    weak var presentedViewController:UIViewController?
    
    init(viewController:UIViewController, returningCommand:Command?) {
        self.presentingViewController = viewController
        self.returningCommand = returningCommand
        super.init()
    }
    
    func execute(completed:CommandCompleted?) {
        self.completed = completed
    }
    
    internal func reportRetryError(message:String) {
        DispatchQueue.main.async {
            self.topController.showRetryAlertMessage(message: message) { (action) in
                self.execute(completed: self.completed)
            }
        }
    }
    
    internal func reportError(message:String) {
        DispatchQueue.main.async {
            self.topController.showAlertMessage(message: message)
        }
    }
	
	var topController: UIViewController {
		return self.presentedViewController ?? self.presentingViewController
	}
    
    func finished() {
        self.completed?()
        returningCommand?.execute(completed: nil)
    }
}
