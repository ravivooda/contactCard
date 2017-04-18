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
    static func syncContacts(contactIDs: [String], callingViewController:UIViewController?, success:newSuccess?, fail:newFail?) -> Void {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Manager.contactsRecordType, predicate: predicate)
        
        Manager.contactsContainer.sharedCloudDatabase.fetchAllRecordZones { (recordZones, error) in
            if error != nil {
                fail?(error!.localizedDescription, error!)
                return
            }

            if recordZones == nil {
                success?([])
                return
            }
            
            
            apiPerform(query, inZoneWith: recordZones![0].zoneID, database: Manager.contactsContainer.sharedCloudDatabase, viewController: callingViewController, success: success, fail: fail)
        }
    }
}
