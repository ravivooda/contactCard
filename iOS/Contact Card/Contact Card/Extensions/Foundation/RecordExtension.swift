//
//  RecordExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import CloudKit
import Contacts

extension CKRecord {
    func setupContactData(contact:CNContact) {
        self[CNContact.CardJSONKey] = contact.data.json as NSString
        self[CNContact.FirstNameKey] = contact.givenName as NSString
        self[CNContact.LastNameKey] = contact.familyName as NSString
        
        if let imageData = contact.imageData {
            do {
                let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp_image.png")
                try imageData.write(to: tempFileURL)
                self[CNContact.ImageKey] = CKAsset(fileURL: tempFileURL)
            } catch let error {
                print("Error occurred in setting up the image asset \(error)")
                // Ignore image
            }
        }
    }
    
    func getContactName() -> String {
        var fullName = "\(self[CNContact.FirstNameKey] ?? "" as NSString)"
        if let last = self[CNContact.LastNameKey] {
            fullName.append(" \(last)")
        }
        return fullName
    }
    
    var contactShare:CKShare {
        let share = CKShare(rootRecord: self)
        share[CKShareTitleKey] = "\(self.getContactName())" as CKRecordValue
        return share
    }
    
    var recordIdentifier:String {
        get {
            if let createdUserID = self.creatorUserRecordID {
                return "\(createdUserID.recordName).\(self.recordID.recordName)"
            }
            
            return ""
        }
    }
    
    func getNotificationNameForRecord() -> NSNotification.Name {
        return NSNotification.Name(rawValue: "ContactCardNotification.\(self.recordID.recordName)")
    }
}
