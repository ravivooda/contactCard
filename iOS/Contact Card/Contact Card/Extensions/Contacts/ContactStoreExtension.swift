//
//  ContactStoreExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/3/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Contacts
import ContactsUI

extension CNContactStore {
    func fetchAllContacts() throws -> [CCContact] {
        var contacts:[CCContact] = []
        let keysToFetch = [CNContactViewController.descriptorForRequiredKeys(),
                           CNContactImageDataKey,
                           CNContactIdentifierKey,
                           CNContactNoteKey] as [Any]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        try self.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
            contacts.append(CCContact(contact: contact))
        })
        return contacts
    }
    
    static let ContactsChangedNotification = Notification.Name(rawValue: "Contacts.changedNotification")
    
}
