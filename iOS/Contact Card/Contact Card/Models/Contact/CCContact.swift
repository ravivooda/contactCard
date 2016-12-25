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
	
	let contact:CNContact
	
	let remoteID:String
	
	init(contact:CNContact) {
		self.contact = contact
		var remoteID = ""
		for note in contact.note.components(separatedBy: "\n") {
			if note.contains("Card ID:") {
				remoteID = note.substring(from: note.index(note.startIndex, offsetBy: 9))
			}
		}
		self.remoteID = remoteID
	}

	func displayName() -> String {
		return "\(contact.givenName)"
	}
}
