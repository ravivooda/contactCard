//
//  ShareContactCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class ShareContactCommand: Command, UICloudSharingControllerDelegate {
    let record:CKRecord
    let database:CKDatabase
    
    init(withRecord record:CKRecord, database:CKDatabase, viewController: UIViewController, returningCommand: Command?) {
        self.database = database
        self.record = record
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        let shareController = UICloudSharingController(preparationHandler: { (controller, preparationCompletionHandler) in
            if let shareRef = self.record.share {
                self.database.fetch(withRecordID: shareRef.recordID, completionHandler: { (shareRecord, error) in
                    self.completePreparationForSharing(share: shareRecord as? CKShare, error: error, preparationCompletionHandler: preparationCompletionHandler)
                })
            } else {
                // This will probably be never executed
                let share = self.record.contactShare
                let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [share], recordIDsToDelete: nil)
                modifyRecordsOperation.timeoutIntervalForRequest = 10
                modifyRecordsOperation.timeoutIntervalForResource = 10
                modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                    self.completePreparationForSharing(share: share, error: error, preparationCompletionHandler: preparationCompletionHandler)
                }
                Manager.contactsContainer.privateCloudDatabase.add(modifyRecordsOperation)
            }
        })
        
        shareController.delegate = self
        shareController.availablePermissions = [.allowReadOnly,.allowPublic]
        self.presentingViewController.present(shareController, animated: true, completion: nil)
    }
    
    private func completePreparationForSharing(share:CKShare?, error:Error?, preparationCompletionHandler:(CKShare?, CKContainer?, Error?) -> Swift.Void) {
        preparationCompletionHandler(share, Manager.contactsContainer, error)
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
        return "Sharing \(record[CNContact.CardNameKey] as? String ?? record.getContactName())"
    }
}
