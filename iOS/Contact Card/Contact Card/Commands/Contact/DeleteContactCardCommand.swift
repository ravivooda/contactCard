//
//  DeleteContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class DeleteContactCardCommand: Command {
    private let card:CCCard
    
    init(card:CCCard, viewController: UIViewController, returningCommand: Command?) {
        self.card = card
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    private func reportError(message:String) {
        self.presentingViewController.showRetryAlertMessage(message: message) { (action) in
            self.execute(completed: self.completed)
        }
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let confirmDeleteAction = UIAlertController(title: "Delete card \(card.record.getContactName())", message: "Are you sure you want to delete this card? You can edit your card followers instead", preferredStyle: .actionSheet)
        confirmDeleteAction.addAction(UIAlertAction(title: "Edit Participants", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                if let shareRecord = self.card.record.share {
                    Manager.contactsContainer.privateCloudDatabase.fetch(withRecordID: shareRecord.recordID, completionHandler: { (record, error) in
                        DispatchQueue.main.async {
                            guard error == nil, let share = record as? CKShare else {
                                return self.reportError(message: error?.localizedDescription ?? "An error occurred while fetching share details")
                            }
                            
                            if let participantsController = self.presentingViewController.storyboard?.instantiateViewController(withIdentifier: "participantsTableViewController") as? ParticipantsTableViewController {
                                participantsController.share = share
                                participantsController.command = self
                                self.presentingViewController.present(UINavigationController(rootViewController: participantsController), animated: true, completion: nil)
                            } else {
                                return self.reportError(message: "An error occurred while setting up your participants controller")
                            }
                        }
                    })
                }
            }
        }))
        confirmDeleteAction.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { (action) in
            DispatchQueue.main.async {
                Manager.contactsContainer.privateCloudDatabase.delete(withRecordID: self.card.record.recordID, completionHandler: { (record, error) in
                    guard error == nil else {
                        return self.reportError(message: error?.localizedDescription ?? "An error occurred in deleting your card from remote server")
                    }
                    print("Successfully deleted card \(self.card.record.getContactName())")
                    self.finished()
                })
            }
        }))
        confirmDeleteAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.presentingViewController.present(confirmDeleteAction, animated: true, completion: nil)
    }
}
