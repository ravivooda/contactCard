//
//  Contact.swift
//  Contact Card
//
//  Created by Ravi Vooda on 3/25/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension Data {
    static func syncContacts(callingViewController:UIViewController?, success:newSuccess?, fail:newFail?) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Manager.contactsRecordType, predicate: predicate)
        
        Manager.contactsContainer.sharedCloudDatabase.fetchAllRecordZones { (recordZones, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    return reportError(error: error!, fail: fail)
                }
                
                guard let recordZones = recordZones else {
                    return reportSuccess(success: success, records: [])
                }
                
                for recordZone in recordZones {
                    if recordZone.zoneID.zoneName == Manager.contactsZone {
                        return apiPerform(query, inZoneWith: recordZone.zoneID, database: Manager.contactsContainer.sharedCloudDatabase, viewController: callingViewController, success: success, fail: fail)
                    }
                }
                success?([])
            }
        }
    }
}
