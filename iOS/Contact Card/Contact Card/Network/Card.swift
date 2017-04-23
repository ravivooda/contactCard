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
    static func addCard(name:String, contact:CNContact, callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        // Create zone if required
        let contactsRecordZone = CKRecordZone(zoneName: Manager.contactsZone)
        Manager.contactsContainer.privateCloudDatabase.save(contactsRecordZone) { (recordZone, error) in
            if let error = error {
                return reportError(error: error, fail: fail)
            }
            
            // Adding the record
            let contactRecord = CKRecord(recordType: Manager.contactsRecordType, zoneID:recordZone!.zoneID)
            contactRecord.setupContactData(contact: contact)
            contactRecord[CNContact.CardNameKey] = name as NSString
            
            let contactShare = CKShare(rootRecord: contactRecord)
            contactShare.publicPermission = .readOnly
            
            let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [contactRecord, contactShare], recordIDsToDelete: nil)
            modifyRecordsOperation.timeoutIntervalForRequest = 10
            modifyRecordsOperation.timeoutIntervalForResource = 10
            
            modifyRecordsOperation.modifyRecordsCompletionBlock = {
                records, recordIDs, error in
                if let error = error {
                    return reportError(error: error, fail: fail)
                }
                reportSuccess(success: success, records: records ?? [])
            }
            Manager.contactsContainer.privateCloudDatabase.add(modifyRecordsOperation)
        }
    }
    
    static func myCards(callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        let query = CKQuery(recordType: Manager.contactsRecordType, predicate: NSPredicate(value: true))
        let contactsRecordZone = CKRecordZone(zoneName: Manager.contactsZone)
        apiPerform(query, inZoneWith: contactsRecordZone.zoneID, viewController: callingViewController, success: success, fail: fail)
    }
    
    static func editCard(card:CCCard, contact:CNContact, callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        let record = card.record
        record.setupContactData(contact: contact)
        
        let modifyRecordOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modifyRecordOperation.savePolicy = .ifServerRecordUnchanged
        modifyRecordOperation.qualityOfService = .userInitiated
        modifyRecordOperation.modifyRecordsCompletionBlock = {
            records, recordIDs, error in
            if let error = error {
                return reportError(error: error, fail: fail)
            }
            reportSuccess(success: success, records: records ?? [])
            for record in records ?? [] {
                var message = "\(contact.givenName)"
                if !isEmpty(contact.familyName) {
                    message += " \(contact.familyName)"
                }
                message += " has updated contact information"
                self.sendUpdateNotification(forRecord: record, message: message, viewController: nil, success: nil, fail: nil)
            }
        }
        Manager.contactsContainer.privateCloudDatabase.add(modifyRecordOperation)
    }
}
