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
	
	var contact:CNContact
	
	init(contact:CNContact) {
		self.contact = contact
	}

	func displayName() -> String {
		return "\(contact.givenName)"
	}
}
