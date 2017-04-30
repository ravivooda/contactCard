//
//  Manager.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Alamofire
import Contacts
import CloudKit

class Manager: NSObject {
    
    fileprivate override init() {
        super.init()
    }
    
    static let contactsContainer = CKContainer.default()
    static let contactsZone = "ContactCards"
    static let contactsRecordType = "Contact"
    
    static func defaultManager() -> Manager {
        struct Static {
            static let instance: Manager = Manager()
        }
        return Static.instance
    }
    
    func addNewCard(name: String, card:CNMutableContact, callingViewController:UIViewController, success:@escaping Data.newSuccess, fail:@escaping Data.newFail) -> Void {
        Data.addCard(name: name, contact: card, callingViewController: callingViewController, success: { (records) in
            self.cards.append(CCCard(record: records[0], contact: card))
            success(records)
        }, fail: fail)
    }
    
    func refreshCards(callingViewController:UIViewController, success:@escaping Data.newSuccess, fail:@escaping Data.newFail) -> Void {
        Data.myCards(callingViewController: callingViewController, success: { (records) in
            self.cards = []
            for record in records {
                self.cards.append(CCCard(record: record))
            }
            success(records)
        }, fail: fail)
    }
    
    func editCard(card:CCCard, contact:CNContact, callingViewController:UIViewController, success:@escaping Data.newSuccess, fail:@escaping Data.newFail) {
        Data.editCard(card: card, contact: contact, callingViewController: callingViewController, success: success, fail: fail)
    }
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
}
