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
    
    var progress:Float = -1 {
        didSet {
            contactAddingDelegate?.contactUpdateProgress(value: progress)
        }
    }
    
    init(record:CKRecord, viewController:UIViewController, returningCommand:Command?) {
        self.record = record
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        self.progress = 0
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.record.recordID) { (record, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.contactAddingDelegate?.contactUpdateError(error: error!)
                    self.progress = -1
                    return
                }
                
                guard let record = record else {
                    self.contactAddingDelegate?.contactUpdateError(error: UpdateContactError(message: "An error occurred while fetching the contact information. Please makes sure your device has active internet connection"))
                    self.progress = -1
                    return
                }
                
                let contact = CNMutableContact(withRecord: record)
                contact.note = contact.note.appending("\n\(CCContact.referenceKey)\(record.recordIdentifier)")
                let saveRequest = CNSaveRequest()
                saveRequest.add(contact, toContainerWithIdentifier: nil)
                do {
                    try Manager.contactsStore.execute(saveRequest)
                    self.progress = 1
                } catch let error {
                    print("Error occurred while saving the request \(error)")
                    self.contactAddingDelegate?.contactUpdateError(error: UpdateContactError(message: "An error occurred while saving the contact locally. Please ensure that the app has write permissions to your contacts"))
                }
            }
        }
    }
    
    func deleteContact(completed: CommandCompleted?) {
        
    }
}
