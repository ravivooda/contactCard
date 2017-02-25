//
//  CCCardJSONExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import Contacts

extension CCCard {
    convenience init(payload:[String : AnyObject]) {
        let contact = CNContact()
        self.init(contact: contact)
    }
}
