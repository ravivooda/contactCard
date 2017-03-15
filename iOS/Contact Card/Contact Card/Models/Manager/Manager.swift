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
    
    func refreshCards(callingViewController:UIViewController, success:@escaping Data.Success, fail:@escaping Data.Fail) -> Void {
        Data.myCards(callingViewController: callingViewController, success: { (data:[String: Any]) in
            if let _cardsDict = data["cards"] {
                if let cardsDict = _cardsDict as? [[String: Any]] {
                    self.cards = []
                    for cardDict in cardsDict {
                        let id = getIntValue(cardDict["contact_id"])
                        
                        if id > 0, let value = cardDict["value"] as? String {
                            if let actualDict = convertToDictionary(text: value) {
                                let card = CCCard(id: id, payload: actualDict)
                                self.cards.append(card)
                            }
                        }
                    }
                    success(data)
                    return
                }
            }
        }, fail: { (data, response) in
            fail(data, response)
            
        })
    }
    
    func editCard(card:CCCard, contact:CNContact, callingViewController:UIViewController, success:@escaping Data.Success, fail:@escaping Data.Fail) {
        Data.editCard(id: "\(card.id)", data: CCCard.toData(contact, imageURL: nil, thumbImageURL: nil), callingViewController: callingViewController, success: success, fail: fail)
    }
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
    
}
