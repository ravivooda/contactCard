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
    
    init(contact:CCContact, viewController: UIViewController, returningCommand: Command?) {
        self.contact = contact
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    private func reportError(message:String) {
        self.presentingViewController.showRetryAlertMessage(message: message) { (action) in
            self.execute(completed: self.completed)
        }
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let deleteAlertController = UIAlertController(title: "Delete contact \(contact.displayName())", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
        deleteAlertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            guard let identifier = self.contact.contactIdentifier else {
                return self.deleteLocalContactCopy()
            }
            
            Manager.contactsContainer.sharedCloudDatabase.delete(withRecordID: CKRecordID(recordName: identifier.recordName), completionHandler: { (record, error) in
                DispatchQueue.main.async {
                    guard error == nil, let _ = record else {
                        return self.reportError(message: error?.localizedDescription ?? "Apologies. An error occurred while deleting the contact share. Please make sure the device is connected to internet")
                    }

                    self.deleteLocalContactCopy()
                }
            })
        }))
        self.presentingViewController.present(deleteAlertController, animated: true, completion: nil)
    }
    
    private func deleteLocalContactCopy() {
        let deleteRequest = CNSaveRequest()
        if let mutableCopy = self.contact.contact.mutableCopy() as? CNMutableContact {
            deleteRequest.delete(mutableCopy)
            do {
                try Manager.contactsStore.execute(deleteRequest)
                NotificationCenter.contactCenter.post(name: CNContactStore.ContactsChangedNotification, object: nil)
            } catch let error {
                self.reportError(message: error.localizedDescription)
            }
        }
    }
}
