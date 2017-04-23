//
//  ShareContactCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit

class ShareContactCommand: Command {
    let record:CKRecord
    
    init(withRecord record:CKRecord, viewController: UIViewController, returningCommand: Command?) {
        self.record = record
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        /*let shareController = UICloudSharingController(preparationHandler: { (controller, preparationCompletionHandler) in
            let share = CKShare(rootRecord: self.record)
            share[CKShareTitleKey] = " My First Share" as CKRecordValue
            
            let fullName = "\(self.record["owner_first_name"] ?? "" as String as CKRecordValue) \(self.record["owner_last_name"] ?? "" as String as CKRecordValue)"
            
            let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [sharingCard.record, share], recordIDsToDelete: nil)
            
            modifyRecordsOperation.timeoutIntervalForRequest = 10
            modifyRecordsOperation.timeoutIntervalForResource = 10
            
            modifyRecordsOperation.modifyRecordsCompletionBlock = { records,
                recordIDs, error in
                if error != nil {
                    print(error)
                    print(error?.localizedDescription ?? "")
                }
                print(share.url)
                preparationCompletionHandler(share, Manager.contactsContainer, error)
            }
            Manager.contactsContainer.privateCloudDatabase.add(modifyRecordsOperation)
        })
        
        //shareController.delegate = self
        shareController.availablePermissions = [.allowReadOnly,.allowPublic]
        self.present(shareController, animated: true, completion: {
            //print("share URL: \(share.url)")
        })*/
    }
}
