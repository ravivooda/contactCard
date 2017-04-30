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
        let confirmDeleteAction = UIAlertController(title: "Delete card \(card.record.getContactName())", message: "Are you sure you want to delete this card? You can edit your card followers", preferredStyle: .actionSheet)
        confirmDeleteAction.addAction(UIAlertAction(title: "Edit Participants", style: .default, handler: { (action) in
            //print("Should delete the card updating the card holders")
            //self.reportError(message: "An error occurred while deleting")
            if let shareRecord = self.card.record.share {
                Manager.contactsContainer.privateCloudDatabase.fetch(withRecordID: shareRecord.recordID, completionHandler: { (record, error) in
                    DispatchQueue.main.async {
                        guard error == nil, let share = record as? CKShare else {
                            return self.reportError(message: error?.localizedDescription ?? "An error occurred while fetching share details")
                        }
                        
                    }
                })
            }
        }))
        confirmDeleteAction.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { (action) in
            print("Should delete the card without updating the card holders")
        }))
        confirmDeleteAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.presentingViewController.present(confirmDeleteAction, animated: true, completion: nil)
        /*let deleteAlertController = UIAlertController(title: "Delete card \(card.record.getContactName())", message: "Are you sure you want to delete this card? This cannot be undone.\n", preferredStyle: .alert)
        deleteAlertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
        }))
        deleteAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.presentingViewController.present(deleteAlertController, animated: true, completion: nil)*/
    }
    
    override func finished() {
        super.finished()
    }
}
