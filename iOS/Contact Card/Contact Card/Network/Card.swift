//
//  Card.swift
//  Contact Card
//
//  Created by Ravi Vooda on 2/12/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension Data {
    static func addCard(name:String, data:[String: Any], callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        
        // Create zone if required
        let contactsRecordZone = CKRecordZone(zoneName: Manager.contactsZone)
        Manager.contactsContainer.privateCloudDatabase.save(contactsRecordZone) { (recordZone, error) in
            if error != nil {
                print(error)
            }
            print(recordZone)
            
            // Adding the record
            let contactRecord = CKRecord(recordType: Manager.contactsRecordType, zoneID:recordZone!.zoneID)
            
            contactRecord["json"] = data.json as NSString
            contactRecord["name"] = name as NSString
            
            let contactShare = CKShare(rootRecord: contactRecord)
            
            contactShare.publicPermission = .readOnly
            
            let modifyRecordsOperation = CKModifyRecordsOperation(
                recordsToSave: [contactRecord, contactShare],
                recordIDsToDelete: nil)
            modifyRecordsOperation.timeoutIntervalForRequest = 10
            modifyRecordsOperation.timeoutIntervalForResource = 10
            
            modifyRecordsOperation.modifyRecordsCompletionBlock = {
                records, recordIDs, error in
                if error != nil {
                    print(error)
                }
                print(records)
                print(contactShare.url)
            }
            Manager.contactsContainer.privateCloudDatabase.add(modifyRecordsOperation)
        }
        //apiSave(contactRecord, viewController: callingViewController, success: success, fail: fail)
    }
    
    static func myCards(callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        let query = CKQuery(recordType: Manager.contactsRecordType, predicate: NSPredicate(value: true))
        let contactsRecordZone = CKRecordZone(zoneName: Manager.contactsZone)
        apiPerform(query, inZoneWith: contactsRecordZone.zoneID, viewController: callingViewController, success: success, fail: fail)
    }
    
    static func editCard(card:CCCard, callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        //api(.post, api: "card", parameters: [ "data" : data.json, "card_id" : id ], viewController: callingViewController, success: success, fail: fail)
    }
}
