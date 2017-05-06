//
//  NewContactsAvailableTableViewCell.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/6/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class NewContactsAvailableTableViewCell: UITableViewCell {

    @IBOutlet weak var contactsNumberLabel: UILabel!
    @IBOutlet weak var stackThumbnailView: StackThumbnailView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var newContacts:[AddContactCardCommand]! {
        didSet {
            self.contactsNumberLabel.text = "\(self.newContacts.count) card\(self.newContacts.count != 1 ? "s" : "") available"
            self.stackThumbnailView.newContacts = self.newContacts
        }
    }
}
