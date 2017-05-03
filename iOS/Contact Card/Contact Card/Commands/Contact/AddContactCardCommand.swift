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
    
    var progress:Float = -1 {
        didSet {
            NotificationCenter.contactCenter.post(name: self.record.getNotificationNameForRecord(), object: self.record, userInfo: [CCContact.ContactNotificationProgressInfoKey:self.progress])
        }
    }
    
    init(record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.record = record
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    private func reportError(error:Error) {
        self.progress = -1
        print("Adding card error: \(error)")
        NotificationCenter.contactCenter.post(name: self.record.getNotificationNameForRecord(), object: self.record, userInfo: [CCContact.ContactNotificationProgressErrorKey:error])
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        self.progress = 0
        print("Fetching record with ID: \(self.record.recordID) to add to the contacts")
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.record.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    return self.reportError(error: error!)
                }
                
                guard let record = record else {
                    return self.reportError(error: UpdateContactError(message: "An error occurred while fetching the contact information. Please makes sure your device has active internet connection"))
                }
                
                let contact = CNMutableContact(withRecord: record)
                contact.note = contact.note.appending("\n\(CCContact.referenceKey)\(record.recordIdentifier)/\(record.recordChangeTag ?? "")")
                let saveRequest = CNSaveRequest()
                saveRequest.add(contact, toContainerWithIdentifier: nil)
                do {
                    try Manager.contactsStore.execute(saveRequest)
                    self.progress = 1
                } catch let error {
                    print("Error occurred while saving the request \(error)")
                    return self.reportError(error: error)
                }
                self.addedContact = contact
                self.finished()
            }
        }
    }
    
    func deleteContact(completed: CommandCompleted?) {
        
    }
}
