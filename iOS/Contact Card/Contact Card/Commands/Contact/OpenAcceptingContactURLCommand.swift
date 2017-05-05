//
//  OpenAcceptingContactURLCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/2/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class OpenAcceptingContactURLCommand: Command {
    let cloudKitShareMetadata:CKShareMetadata
    
    init(cloudKitShareMetadata: CKShareMetadata, viewController: UIViewController, returningCommand: Command?) {
        self.cloudKitShareMetadata = cloudKitShareMetadata
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        let acceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        acceptSharesOperation.qualityOfService = .userInteractive
        acceptSharesOperation.perShareCompletionBlock = {
            metadata, share, error in
            DispatchQueue.main.async {
                guard error == nil, let share = share else {
                    print(error?.localizedDescription ?? "")
                    self.presentingViewController.showAlertMessage(message: "Error occurred in accepting share (new contact). Please ensure that the device is connected to network and try opening the shared link")
                    return
                }
                
                if UserDefaults.isAutoSyncEnabled {
                    self.addContactIfNeededAndShow()
                } else {
                    let acceptedAlertViewController = UIAlertController(title: "Accepted share", message: "Shall we add this contact to your local contacts?", preferredStyle: .alert)
                    acceptedAlertViewController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                        self.addContactIfNeededAndShow()
                    }))
                    acceptedAlertViewController.addAction(UIAlertAction(title: "Not now", style: .destructive, handler: nil))
                    self.presentingViewController.present(acceptedAlertViewController, animated: true, completion: nil)
                }
                
                print("Successfully accepted share \(share) with metadata \(metadata)")
            }
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptSharesOperation)
    }
    
    private func addContactIfNeededAndShow() {
        print("Trying to fetch root record ID: \(self.cloudKitShareMetadata.rootRecordID)")
        let currentViewController = AppDelegate.myContactsViewController ?? self.presentingViewController
        Manager.contactsContainer.sharedCloudDatabase.fetch(withRecordID: self.cloudKitShareMetadata.rootRecordID, completionHandler: { (record, error) in
            DispatchQueue.main.async {
                guard error == nil, let record = record else {
                    print("Error occurred while fetching record \(error?.localizedDescription ?? "")")
                    return self.presentingViewController.showAlertMessage(message: "Accepted the share. But unable to fetch the share at the moment. No worries they will be added into your contacts automatically")
                }
                
                do {
                    let contacts = try Manager.contactsStore.fetchAllContacts()
                    for contact in contacts {
                        if let identifier = contact.contactIdentifier, identifier.remoteID == record.recordIdentifier {
                            // Found an existing contact
                            return ShowContactCommand(contact: contact.contact, viewController: currentViewController, returningCommand: nil).execute(completed: nil)
                        }
                    }
                    
                    // Did not find the contact
                    let addContactCardCommand = AddContactCardCommand(record: record, viewController: currentViewController, returningCommand: nil)
                    addContactCardCommand.execute(completed: {
                        if let contact = addContactCardCommand.addedContact {
                            ShowContactCommand(contact: contact, viewController: currentViewController, returningCommand: nil).execute(completed: nil)
                        }
                    })
                } catch let error {
                    currentViewController.showAlertMessage(message: "An error occurred while fetching your contacts - \(error.localizedDescription)")
                }
            }
        })
    }
}
