//
//  CCContact.swift
//  Contact Card
//
//  Created by Ravi Vooda on 12/24/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Contacts
import CloudKit

class CCContact {
    static let referenceKey = "Contact Card Reference:"
	
	let contact:CNContact
	
	let remoteID:String
	
	init(contact:CNContact) {
		self.contact = contact
		var remoteID = ""
		for note in contact.note.components(separatedBy: "\n") {
			if note.contains(CCContact.referenceKey) {
				remoteID = note.substring(from: note.index(note.startIndex, offsetBy: CCContact.referenceKey.characters.count))
                break
			}
		}
		self.remoteID = remoteID
	}

	func displayName() -> String {
		return "\(contact.givenName) \(contact.familyName)"
	}
    
    var updateRecord:CKRecord? = nil
    var updateContactOperation:UpdateContactOperation? = nil
}
