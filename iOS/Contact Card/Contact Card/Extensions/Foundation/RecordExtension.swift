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
            } catch _ {
                // Ignore image
            }
        }
    }
}
