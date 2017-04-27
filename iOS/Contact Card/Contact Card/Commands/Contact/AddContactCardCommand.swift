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
    var contactAddingDelegate:ContactUpdateDelegate?
    
    
    init(record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.record = record
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        contactAddingDelegate?.contactUpdateProgress(value: 0)
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.record.recordID) { (record, error) in
            guard error != nil else {
                self.contactAddingDelegate?.contactUpdateError(error: error!)
                return
            }
            
            guard let record = record else {
                self.contactAddingDelegate?.contactUpdateError(error: UpdateContactError(message: "An error occurred while fetching the contact information. Please makes sure your device has active internet connection"))
                return
            }
            
            let contact = CNMutableContact(withRecord: record)
            contact.note = contact.note.appending("\n\(CCContact.referenceKey)\(record.recordIdentifier)")
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            do {
                try Manager.contactsStore.execute(saveRequest)
                DispatchQueue.main.async {
                    self.contactAddingDelegate?.contactUpdateProgress(value: 1)
                }
            } catch let error {
                print("Error occurred while saving the request \(error)")
                self.contactAddingDelegate?.contactUpdateError(error: UpdateContactError(message: "An error occurred while saving the contact locally. Please ensure that the app has write permissions to your contacts"))
            }
        }
    }
}
