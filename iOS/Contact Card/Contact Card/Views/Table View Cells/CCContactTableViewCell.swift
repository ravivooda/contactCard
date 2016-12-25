//
//  CCContactTableViewCell.swift
//  Contact Card
//
//  Created by Ravi Vooda on 12/24/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class CCContactTableViewCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var leftContainer: UIView!

    private var contact:CCContact?
	
	func setContact(contact:CCContact) {
		self.contact = contact
		
		self.nameLabel.text = contact.displayName();
	}
	
	func getContact() -> CCContact? {
		return contact
	}
}
