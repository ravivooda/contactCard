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
import UIKit

class CCCard {
    static let dateFormat = "yyyy/MM/dd hh:mm Z"
    
    let contact:CNMutableContact
    let record:CKRecord
    
    init(record:CKRecord, contact:CNMutableContact) {
        self.contact = contact
        self.record = record
        
        self.generateThumbnailImage()
    }
    
    private func generateThumbnailImage() {
        // First save the contact for it to generate
        let saveRequest = CNSaveRequest()
        saveRequest.add(self.contact, toContainerWithIdentifier: nil)
        do {
            try Manager.contactsStore.execute(saveRequest)
        } catch let error {
            print("Error occurred while saving the request \(error)")
        }
        
        // Now delete the contact
        let deleteRequest = CNSaveRequest()
        deleteRequest.delete(self.contact)
        do {
            try Manager.contactsStore.execute(deleteRequest)
        } catch let error  {
            print("Error occurred while deleting the request \(error)")
        }
    }
    
    convenience init(record:CKRecord) {
        let contact = CNMutableContact(withRecord: record)
        self.init(record: record, contact: contact)
    }
    
    var cardName:String {
        return self.record[CNContact.CardNameKey] as? String ?? ""
    }
    
}
