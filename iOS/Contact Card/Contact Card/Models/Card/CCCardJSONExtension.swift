//
//  CCCardJSONExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import Contacts
import CloudKit

extension CCCard {
    convenience init(record:CKRecord) {
        let contact = CNMutableContact(withRecord: record)
        self.init(record: record, contact: contact)
    }
}
