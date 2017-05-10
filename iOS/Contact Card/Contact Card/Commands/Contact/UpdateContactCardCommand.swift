//
//  UpdateContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import CloudKit
import Contacts
import UIKit

class UpdateContactCardCommand: Command {
    let record:CKRecord
    let contact:CCContact
    var progress:Float = -1 {
        didSet {
            NotificationCenter.contactCenter.post(name: self.record.getNotificationNameForRecord(), object: self.record, userInfo: [CCContact.ContactNotificationProgressInfoKey:self.progress])
        }
    }
    
    init(contact:CCContact, record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.contact = contact
        self.record = record
        super.init(viewController: viewController, returningCommand: nil)
    }
    
    override func reportError(message: String) {
        DispatchQueue.main.async {
            self.progress = -1
            print("Error in updating contact: \(message)")
            NotificationCenter.contactCenter.post(name: self.record.getNotificationNameForRecord(), object: self.record, userInfo: [CCContact.ContactNotificationProgressErrorKey:message])
        }
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        self.progress = 0
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.record.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil,
                    let record = record,
                    let payload = record[CNContact.CardJSONKey] as? String,
                    let jsonPayload = convertToDictionary(text: payload),
                    let mutableContact = self.contact.contact.mutableCopy() as? CNMutableContact else {
                    return self.reportError(message: error?.localizedDescription ?? "An unknown error occurred while fetching the asset. Please ensure that your device has an active internet connection")
                }
                
                if let asset = record[CNContact.ImageKey] as? CKAsset,
                    let imageData = NSData(contentsOf: asset.fileURL) as Foundation.Data? {
                    mutableContact.imageData = imageData
                }
                mutableContact.parse(payload: jsonPayload)
                
                // Save the contact
                let saveRequest = CNSaveRequest()
                saveRequest.update(mutableContact)
                do {
                    try CNContactStore().execute(saveRequest)
                } catch let error {
                    return self.reportError(message: error.localizedDescription)
                }
                self.progress = 1
            }
        }
    }
}
