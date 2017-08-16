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
        self.contact = contact.generateThumbnailImage()
        self.record = record
    }
    
    convenience init(record:CKRecord) {
        let contact = CNMutableContact(withRecord: record)
        self.init(record: record, contact: contact)
    }
    
    var cardName:String {
        return self.record[CNContact.CardNameKey] as? String ?? ""
    }
    
}

extension Array where Element == String {
    mutating func addNonEmptyString(string:String?) {
        if let nonNullableString = string, !nonNullableString.isEmpty {
            self.append(nonNullableString)
        }
    }
}

extension CNMutableContact {
    func generateThumbnailImage() -> Self {
        if self.thumbnailImageData != nil {
            return self
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
        return self
    }
}

extension CNContact {
    var keywords: [String] {
        let allKeywordsArray = [
            self.givenName,
            self.middleName,
            self.familyName,
            self.previousFamilyName,
            self.nickname,
            self.organizationName,
            self.departmentName,
            self.jobTitle,
            self.phoneticGivenName,
            self.phoneticMiddleName,
            self.phoneticFamilyName,
            self.phoneticOrganizationName,
            ]
        var returningKeywordsArray = [String]()
        for key in allKeywordsArray {
            returningKeywordsArray.addNonEmptyString(string: key)
        }
        return returningKeywordsArray
    }
    
    var employmentDescription: String {
        var array = [String]()
        array.addNonEmptyString(string: self.jobTitle)
        array.addNonEmptyString(string: self.departmentName)
        array.addNonEmptyString(string: self.organizationName)
        return array.joined(separator: ", ")
    }
}
