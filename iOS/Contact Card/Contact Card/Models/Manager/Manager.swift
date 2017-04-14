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

class Manager: NSObject {
    
    fileprivate override init() {
        super.init()
    }
    
    static func defaultManager() -> Manager {
        struct Static {
            static let instance: Manager = Manager()
        }
        return Static.instance
    }
    
    func addNewCard(card:CNContact, callingViewController:UIViewController, success:@escaping Data.Success, fail:@escaping Data.Fail) -> Void {
        Data.addCard(data: CCCard.toData(card, imageURL: nil, thumbImageURL: nil), callingViewController: callingViewController, success: { (response) in
            let id = getIntValue(response["contact_id"])
            self.cards.append(CCCard(id: id, contact: card))
            success(response)
        }) { (response, httpResponse) in
            fail(response, httpResponse)
        }
    }
    
    func refreshCards(callingViewController:UIViewController, success:@escaping Data.newSuccess, fail:@escaping Data.newFail) -> Void {
        Data.myCards(callingViewController: callingViewController, success: { (records) in
            self.cards = []
            for record in records {
                if let jsonString = record["json"] as? String, let dictionary = convertToDictionary(text: jsonString) {
                    self.cards.append(CCCard(id: 1, payload: dictionary))
                }
            }
            success(records)
        }, fail: fail)
    }
    
    func editCard(card:CCCard, contact:CNContact, callingViewController:UIViewController, success:@escaping Data.Success, fail:@escaping Data.Fail) {
        Data.editCard(id: "\(card.id)", data: CCCard.toData(contact, imageURL: nil, thumbImageURL: nil), callingViewController: callingViewController, success: success, fail: fail)
    }
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
    
}
