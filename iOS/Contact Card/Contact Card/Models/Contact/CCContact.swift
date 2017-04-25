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

protocol ContactUpdateDelegate {
    func contactUpdateProgress(value:Float)
}

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
    
    class UpdateContactOperation: Operation {
        let record:CKAsset
        var view:ContactUpdateDelegate?
        
        init(record:CKAsset) {
            self.record = record
        }
        
        override func main() {
            if self.isCancelled {
                return
            }
            
            //Manager.contactsContainer.sharedCloudDatabase.fetch
        }
    }
    
    
    func updateContactWithRecord(record:CKRecord) {
        if let mutableContact = contact.mutableCopy() as? CNMutableContact, let payload = record[CNContact.CardJSONKey] as? String, let data = convertToDictionary(text: payload) {
            mutableContact.parse(payload: data)
            
            // Save the contact
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
