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
    
    init(viewController:UIViewController) {
        self.presentingViewController = viewController
        super.init()
    }

    fileprivate override init() {
        self.presentingViewController = UIViewController()
    }
    
    func execute() {
        
    }
}
