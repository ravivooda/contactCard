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
    static func addCard(data:[String: Any], callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        //api(.put, api: "card", parameters: [ "data" : data.json ], viewController: callingViewController, success: success, fail: fail)
        let contactRecord = CKRecord(recordType: "Contact")
        contactRecord["json"] = data.json as NSString
        
        let database = CKContainer.default().privateCloudDatabase
        database.save(contactRecord) { (record, error) in
            //print("record: \(record), error: \(error)")
        }
        
    }
    
    static func myCards(callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        let query = CKQuery(recordType: "Contact", predicate: NSPredicate(value: true))
        api(query, viewController: callingViewController, success: success, fail: fail)
    }
    
    static func editCard(id: String, data:[String: Any], callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        api(.post, api: "card", parameters: [ "data" : data.json, "card_id" : id ], viewController: callingViewController, success: success, fail: fail)
    }
}
