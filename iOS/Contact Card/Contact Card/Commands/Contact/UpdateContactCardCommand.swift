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
    static let ContactNotificationProgressInfoKey = "ContactCard.Progress"
    static let ContactNotificationProgressErrorKey = "ContactCard.Error"
    static let ContactNotificationUpdateAvailableInfoKey = "ContactCard.UpdateAvailable"
    static func getNotificationNameForRecord(record:CKRecord) -> NSNotification.Name {
        return NSNotification.Name(rawValue: "ContactCardNotification.\(record.recordID.recordName)")
    }
    let record:CKRecord
    let updatingContact:CCContact
    var progress:Float = -1 {
        didSet {
            NotificationCenter.contactCenter.post(name: UpdateContactCardCommand.getNotificationNameForRecord(record: self.record), object: self.record, userInfo: [UpdateContactCardCommand.ContactNotificationProgressInfoKey:self.progress])
        }
    }
    
    init(contact:CCContact, record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.updatingContact = contact
        self.record = record
        super.init(viewController: viewController, returningCommand: nil)
    }
    
    private func reportError(error:Error) {
        self.progress = -1
        print("Error in updating contact: \(error)")
        NotificationCenter.contactCenter.post(name: UpdateContactCardCommand.getNotificationNameForRecord(record: self.record), object: self.record, userInfo: [UpdateContactCardCommand.ContactNotificationProgressErrorKey:error])
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        self.progress = 0
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.record.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    return self.reportError(error: error!)
                }
                
                guard let record = record, let payload = record[CNContact.CardJSONKey] as? String, let jsonPayload = convertToDictionary(text: payload), let mutableContact = self.updatingContact.contact.mutableCopy() as? CNMutableContact else {
                    return self.reportError(error: UpdateContactError(message: "An unknown error occurred while fetching the asset. Please ensure that your device has an active internet connection"))
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
                    return self.reportError(error: error)
                }
                self.progress = 1
            }
        }
    }
}
