//
//  AddContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/26/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import CloudKit
import Contacts
import UIKit

class AddContactCardCommand: Command {
    let record:CKRecord
    var addedContact:CNContact?
    var contactReference:CNContact?
    
    var progress:Float = -1 {
        didSet {
            NotificationCenter.contactCenter.post(name: self.record.getNotificationNameForRecord(), object: self.record, userInfo: [CCContact.ContactNotificationProgressInfoKey:self.progress])
        }
    }
    
    init(record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.record = record
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    func generateContactReference() -> CNContact {
        if self.contactReference == nil {
            self.contactReference = CNMutableContact(withRecord: self.record).generateThumbnailImage()
        }
        return self.contactReference!
    }
    
    override func reportError(message: String) {
        DispatchQueue.main.async {
            self.progress = -1
            print("Adding card error: \(message)")
            NotificationCenter.contactCenter.post(name: self.record.getNotificationNameForRecord(), object: self.record, userInfo: [CCContact.ContactNotificationProgressErrorKey:message])
        }
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        self.progress = 0
        print("Fetching record with ID: \(self.record.recordID) to add to the contacts")
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.record.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil, let record = record else {
                    return self.reportError(message: error?.localizedDescription ?? "An error occurred while fetching the contact information. Please makes sure your device has active internet connection")
                }
                
                let contact = CNMutableContact(withRecord: record)
                let saveRequest = CNSaveRequest()
                saveRequest.add(contact, toContainerWithIdentifier: nil)
                do {
                    try Manager.contactsStore.execute(saveRequest)
                    self.progress = 1
                } catch let error {
                    print("Error occurred while saving the request \(error)")
                    return self.reportError(message: error.localizedDescription)
                }
                self.addedContact = contact
                self.finished()
            }
        }
    }
    
    func deleteContact(completed: CommandCompleted?) {
        
    }
}
