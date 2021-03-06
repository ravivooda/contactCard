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
        let recordName:String
        let remoteID:String
        let version:String
        
        init(remoteID:String, version:String) {
            self.remoteID = remoteID
            self.version = version
            
            self.recordName = remoteID.components(separatedBy: ".")[1]
        }
    }
    
    static let referenceKey = "Contact Card Reference:"
    static let ContactNotificationProgressInfoKey = "ContactCard.Progress"
    static let ContactNotificationProgressErrorKey = "ContactCard.Error"
    static let ContactNotificationUpdateAvailableInfoKey = "ContactCard.UpdateAvailable"
	
	let contact:CNContact
    let contactIdentifier:ContactIdentifier?
	
	var record:CKRecord?
    
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

extension Array where Element:NSMutableAttributedString {
	func join(seperator:NSMutableAttributedString) -> NSMutableAttributedString {
		guard self.count > 0 else {
			return NSMutableAttributedString()
		}
		let retAttributedString = self[0]
		for i in 1..<self.count {
			retAttributedString.append(seperator)
			retAttributedString.append(self[i])
		}
		return retAttributedString
	}
}

extension CNContact {
    var attributedDisplayName:NSMutableAttributedString {
		var attributedStringsArray = [NSMutableAttributedString]()
        if !isEmpty(self.givenName) {
            let firstName = NSMutableAttributedString(string: "\(self.givenName)")
            firstName.addAttribute(NSAttributedStringKey.font, value: isEmpty(self.familyName) ? UIFont.boldSystemFont(ofSize: 17) : UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, self.givenName.characters.count))
            attributedStringsArray.append(firstName)
        }
        
        if !isEmpty(self.middleName) {
            let middleName = NSMutableAttributedString(string: "\(self.middleName)")
            middleName.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, self.middleName.characters.count))
            attributedStringsArray.append(middleName)
        }
        
        if !isEmpty(self.familyName) {
            let familyName = NSMutableAttributedString(string: "\(self.familyName)")
            familyName.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSMakeRange(0, self.familyName.characters.count))
			switch (CNContactFormatter.nameOrder(for: self)) {
			case .familyNameFirst:
				attributedStringsArray.insert(familyName, at: 0)
				break
			default:
				attributedStringsArray.append(familyName)
			}
        }
		
		
        return attributedStringsArray.join(seperator: NSMutableAttributedString(string: " "))
    }
}
