//
//  DeleteContactCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/8/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit
import Contacts

class DeleteContactCommand: Command {
    let contact:CCContact
    private let errorFetchingMessage = "Apologies. An error occurred while deleting the contact share. Please make sure the device is connected to internet"
    
    init(contact:CCContact, viewController: UIViewController, returningCommand: Command?) {
        self.contact = contact
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let deleteAlertController = UIAlertController(title: "Delete contact \(contact.displayName())", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
        deleteAlertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            guard let identifier = self.contact.contactIdentifier else {
                return self.deleteLocalContactCopy()
            }
            
            Manager.contactsContainer.sharedCloudDatabase.fetchAllRecordZones(completionHandler: { (recordZones, error) in
                guard error == nil, let recordZones = recordZones else {
                    return self.reportError(message: error?.localizedDescription ?? self.errorFetchingMessage)
                }
                
                for zone in recordZones {
                    if zone.zoneID.zoneName == Manager.contactsZone {
                        let recordID = CKRecordID(recordName: identifier.recordName, zoneID: zone.zoneID)
                        return self.deleteRemoteContactCopy(recordID: recordID)
                    }
                }
                
                // This should not happen
                return self.reportError(message: self.errorFetchingMessage)
            })
        }))
        self.presentingViewController.present(deleteAlertController, animated: true, completion: nil)
    }
    
    private func deleteRemoteContactCopy(recordID:CKRecordID) {
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            guard error == nil, let record = record, let share = record.share else {
                return self.reportError(message: error?.localizedDescription ?? self.errorFetchingMessage)
            }
            
            Manager.contactsContainer.sharedCloudDatabase.delete(withRecordID: share.recordID, completionHandler: { (record, error) in
                DispatchQueue.main.async {
                    guard error == nil, let _ = record else {
                        return self.reportError(message: error?.localizedDescription ?? self.errorFetchingMessage)
                    }
                    
                    self.deleteLocalContactCopy()
                }
            })
        }
    }
    
    private func deleteLocalContactCopy() {
        let deleteRequest = CNSaveRequest()
        if let mutableCopy = self.contact.contact.mutableCopy() as? CNMutableContact {
            deleteRequest.delete(mutableCopy)
            do {
                try Manager.contactsStore.execute(deleteRequest)
                self.finished()
            } catch let error {
                self.reportError(message: error.localizedDescription)
            }
        }
    }
    
    override func finished() {
        DispatchQueue.main.async {
            NotificationCenter.contactCenter.post(name: CNContactStore.ContactsChangedNotification, object: nil)
            super.finished()
        }
    }
}
