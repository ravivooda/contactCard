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

class CCContact:CustomDebugStringConvertible {
    class ContactIdentifier {
        let remoteID:String
        let version:String
        
        init(remoteID:String, version:String) {
            self.remoteID = remoteID
            self.version = version
        }
    }
    static let referenceKey = "Contact Card Reference:"
    static let ContactNotificationProgressInfoKey = "ContactCard.Progress"
    static let ContactNotificationProgressErrorKey = "ContactCard.Error"
    static let ContactNotificationUpdateAvailableInfoKey = "ContactCard.UpdateAvailable"
	
	let contact:CNContact
    let contactIdentifier:ContactIdentifier?
    
    init(contact:CNContact) {
		self.contact = contact
        var _contactIdentifier:ContactIdentifier? = nil
        
		for note in contact.note.components(separatedBy: "\n") {
			if note.contains(CCContact.referenceKey) {
				let remoteID = note.substring(from: note.index(note.startIndex, offsetBy: CCContact.referenceKey.characters.count))
                let recordTokens = remoteID.components(separatedBy: "/")
                if recordTokens.count > 1 {
                    _contactIdentifier = ContactIdentifier(remoteID: recordTokens[0], version: recordTokens[1])
                }
                break
			}
		}
        self.contactIdentifier = _contactIdentifier
	}

	func displayName() -> String {
		return "\(contact.givenName) \(contact.familyName)"
	}
    
    var updateContactCommand:UpdateContactCardCommand? = nil {
        didSet {
            if let command = self.updateContactCommand {
                NotificationCenter.contactCenter.post(name: command.record.getNotificationNameForRecord(), object: nil, userInfo: [CCContact.ContactNotificationUpdateAvailableInfoKey : true])
            }
        }
    }
    
    var debugDescription: String {
        get {
            return displayName()
        }
    }
}

extension CNContact {
    var attributedDisplayName:NSMutableAttributedString {
        let retAttributedString = NSMutableAttributedString()
        if !isEmpty(self.givenName) {
            let firstName = NSMutableAttributedString(string: "\(self.givenName) ")
            firstName.addAttribute(NSFontAttributeName, value: isEmpty(self.familyName) ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, self.givenName.characters.count))
            retAttributedString.append(firstName)
        }
        
        if !isEmpty(self.middleName) {
            let middleName = NSMutableAttributedString(string: "\(self.middleName) ")
            middleName.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, self.middleName.characters.count))
            retAttributedString.append(middleName)
        }
        
        if !isEmpty(self.familyName) {
            let familyName = NSMutableAttributedString(string: "\(self.familyName)")
            familyName.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 17), range: NSMakeRange(0, self.familyName.characters.count))
            retAttributedString.append(familyName)
        }
        return retAttributedString
    }
}
