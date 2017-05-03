//
//  CCCard.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import CloudKit
import Contacts

class CCCard {
    static let dateFormat = "yyyy/MM/dd hh:mm Z"
    
    let contact:CNMutableContact
    let record:CKRecord
    
    init(record:CKRecord, contact:CNMutableContact) {
        self.contact = contact
        self.record = record
        
        self.contact.generateThumbnailImage()
    }
    
    convenience init(record:CKRecord) {
        let contact = CNMutableContact(withRecord: record)
        self.init(record: record, contact: contact)
    }
    
    var cardName:String {
        return self.record[CNContact.CardNameKey] as? String ?? ""
    }
    
}

extension CNMutableContact {
    fileprivate func generateThumbnailImage() {
        if self.thumbnailImageData != nil {
            return
        }
        
        // First save the contact for it to generate
        let saveRequest = CNSaveRequest()
        saveRequest.add(self, toContainerWithIdentifier: nil)
        do {
            try Manager.contactsStore.execute(saveRequest)
        } catch let error {
            print("Error occurred while saving the request \(error)")
        }
        
        // Now delete the contact
        let deleteRequest = CNSaveRequest()
        deleteRequest.delete(self)
        do {
            try Manager.contactsStore.execute(deleteRequest)
        } catch let error  {
            print("Error occurred while deleting the request \(error)")
        }
    }
}
