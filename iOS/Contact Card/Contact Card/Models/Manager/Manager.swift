//
//  Manager.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class Manager: NSObject {
    
    fileprivate override init() {
        super.init()
    }
    
    func defaultManager() -> Manager {
        struct Static {
            static let instance: Manager = Manager()
        }
        return Static.instance
    }
}
