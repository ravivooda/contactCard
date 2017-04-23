//
//  CCCard.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import Contacts
import CloudKit

class CCCard {
    static let dateFormat = "yyyy/MM/dd hh:mm Z"
    
    let contact:CNContact
    let record:CKRecord
    
    init(record:CKRecord, contact:CNContact) {
        self.contact = contact
        self.record = record
    }
}
