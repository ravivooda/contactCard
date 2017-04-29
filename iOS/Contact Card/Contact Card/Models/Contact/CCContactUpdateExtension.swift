//
//  CCContactUpdateExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/25/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

struct UpdateContactError:Error {
    let message: String
    init(message:String) {
        self.message = message
    }
    
    var localizedDescription: String {
        return message
    }
}
