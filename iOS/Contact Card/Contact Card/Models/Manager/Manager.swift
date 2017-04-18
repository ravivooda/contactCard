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
    
    static let contactsStore = CNContactStore()
    
    static let contactsContainer = CKContainer.default()
    static let contactsZone = "ContactCards"
    static let contactsRecordType = "Contact"
    
    static func defaultManager() -> Manager {
        struct Static {
            static let instance: Manager = Manager()
        }
        return Static.instance
    }
    
    func addNewCard(name: String, card:CNContact, callingViewController:UIViewController, success:@escaping Data.newSuccess, fail:@escaping Data.newFail) -> Void {
        Data.addCard(name: name, data: CCCard.toData(card, imageURL: nil, thumbImageURL: nil), callingViewController: callingViewController, success: { (records) in
            self.cards.append(CCCard(record: records[0], contact: card))
            success(records)
        }, fail: fail)
    }
    
    func refreshCards(callingViewController:UIViewController, success:@escaping Data.newSuccess, fail:@escaping Data.newFail) -> Void {
        Data.myCards(callingViewController: callingViewController, success: { (records) in
            self.cards = []
            for record in records {
                print("\(record.recordID.recordName)")
                self.cards.append(CCCard(record: record))
            }
            success(records)
        }, fail: fail)
    }
    
    func editCard(card:CCCard, contact:CNContact, callingViewController:UIViewController, success:@escaping Data.Success, fail:@escaping Data.Fail) {
        Data.editCard(card: card, callingViewController: callingViewController, success: success, fail: fail)
    }
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
    
    
    static func getContactIdentifierForRecord(record:CKRecord) -> String? {
        return nil
    }
    
    static func saveNewContactForRecord(record:CKRecord) -> CNContact? {
        if let value = record["value"] as? String, let payload = convertToDictionary(text: value) {
            let contact = CNMutableContact()
            CCCard.parseDataWithMutableContactReference(contact: contact, payload: payload)
            
        }
        return nil
    }
}
