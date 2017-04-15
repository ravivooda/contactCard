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
        let contactRecord = CKRecord(recordType: "Contact")
        contactRecord["json"] = data.json as NSString
        contactRecord["name"] = name as NSString
        
        apiSave(contactRecord, viewController: callingViewController, success: success, fail: fail)
    }
    
    static func myCards(callingViewController:UIViewController, success:newSuccess?, fail:newFail?) -> Void {
        let query = CKQuery(recordType: "Contact", predicate: NSPredicate(value: true))
        apiPerform(query, viewController: callingViewController, success: success, fail: fail)
    }
    
    static func editCard(id: String, data:[String: Any], callingViewController:UIViewController, success:Success?, fail:Fail?) -> Void {
        api(.post, api: "card", parameters: [ "data" : data.json, "card_id" : id ], viewController: callingViewController, success: success, fail: fail)
    }
}
