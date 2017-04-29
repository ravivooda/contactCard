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
    var contact:CCContact! {
        didSet {
            self.nameLabel.text = contact.displayName();
            
            self.leftContainer.isHidden = contact.updateContactOperation != nil
            
            self.rightButton.setTitle(isEmpty(contact.remoteID) ? "Invite" : "Update", for: .normal)
            self.rightButton.tintColor = isEmpty(contact.remoteID) ? self.tintColor : .red
        }
    }

	@IBAction func rightButtonClicked(_ sender: Any) {
		if isEmpty(contact.remoteID) {
			
		}
	}
    
    func updateContact(withRecord record:CKRecord) -> Operation {
        //return UpdateContactOperation(record: record, cell: self)
        return Operation()
    }
}
