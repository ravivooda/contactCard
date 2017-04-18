//
//  CCContact.swift
//  Contact Card
//
//  Created by Ravi Vooda on 12/24/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Contacts

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
    
    func updateContact(data:[String:Any]) {
        if let mutableContact = contact.mutableCopy() as? CNMutableContact {
            CCCard.parseDataWithMutableContactReference(contact: mutableContact, payload: data)
            
            // Save the contact remotely
            let saveRequest = CNSaveRequest()
            saveRequest.update(mutableContact)
            do {
                try CNContactStore().execute(saveRequest)
            } catch let error as NSError {
                print("Error occurred in saving contact update \(error)")
            }
        }
    }
}
