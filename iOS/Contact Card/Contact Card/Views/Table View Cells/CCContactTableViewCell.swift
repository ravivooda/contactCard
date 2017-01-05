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

	@IBOutlet weak var rightButton: UIButton!
    private var contact:CCContact?
	
	func setContact(contact:CCContact) {
		self.contact = contact
		
		self.nameLabel.text = contact.displayName();
		self.rightButton.setTitle(isEmpty(contact.remoteID) ? "Request" : "Update", for: .normal)
	}

	@IBAction func rightButtonClicked(_ sender: Any) {
		if isEmpty(contact?.remoteID) {
			
		}
	}
	
	func getContact() -> CCContact? {
		return contact
	}
}
