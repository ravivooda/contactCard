//
//  CCContactTableViewCell.swift
//  Contact Card
//
//  Created by Ravi Vooda on 12/24/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import CloudKit

class CCContactTableViewCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var leftContainer: UIView!

	@IBOutlet weak var rightButton: UIButton!
    private var contact:CCContact?
	
	func setContact(contact:CCContact) {
		self.contact = contact
		
		self.nameLabel.text = contact.displayName();
        if isEmpty(contact.remoteID) {
            self.rightButton.setTitle("Request", for: .normal)
            self.rightButton.tintColor = self.tintColor
        } else {
            self.rightButton.setTitle("Update", for: .normal)
            self.rightButton.tintColor = .red
        }
	}
    func getContact() -> CCContact? {
        return contact
    }

	@IBAction func rightButtonClicked(_ sender: Any) {
		if isEmpty(contact?.remoteID) {
			
		}
	}
    
    func updateContact(withRecord record:CKRecord) -> Operation {
        //return UpdateContactOperation(record: record, cell: self)
        return Operation()
    }
}
