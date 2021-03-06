//
//  DeleteCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class DeleteCardCommand: Command, UICloudSharingControllerDelegate {
    private let card:CCCard
    
    init(card:CCCard, viewController: UIViewController, returningCommand: Command?) {
        self.card = card
        super.init(viewController: viewController, returningCommand: returningCommand)
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
                                return self.reportRetryError(message: error?.localizedDescription ?? "An error occurred while fetching share details")
                            }
                            
                            let shareController = UICloudSharingController(share: share, container: Manager.contactsContainer)
                            shareController.delegate = self
                            shareController.availablePermissions = [.allowReadOnly,.allowPublic]
                            self.presentingViewController.present(shareController, animated: true, completion: nil)
                        }
                    })
                }
            }
        }))
        confirmDeleteAction.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { (action) in
            DispatchQueue.main.async {
                Manager.contactsContainer.privateCloudDatabase.delete(withRecordID: self.card.record.recordID, completionHandler: { (record, error) in
                    guard error == nil else {
                        return self.reportRetryError(message: error?.localizedDescription ?? "An error occurred in deleting your card from remote server")
                    }
                    print("Successfully deleted card \(self.card.record.getContactName())")
                    self.finished()
                })
            }
        }))
        confirmDeleteAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.presentingViewController.present(confirmDeleteAction, animated: true, completion: nil)
    }
    
    //MARK: - UICloudSharingControllerDelegate -
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("Cloud Sharing Controller did save")
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        print("Cloud Sharing controller did stop sharing")
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("Cloud sharing controller failed to save - \(error)")
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Sharing \(card.record[CNContact.CardNameKey] as? String ?? card.record.getContactName())"
    }
    
    func itemThumbnailData(for csc: UICloudSharingController) -> Foundation.Data? {
        return card.contact.thumbnailImageData
    }
}
