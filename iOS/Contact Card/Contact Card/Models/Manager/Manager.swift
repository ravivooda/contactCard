//
//  Manager.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit
import Alamofire

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
    
    func addNewCard(card:CCCard, callingViewController:UIViewController, success:@escaping Data.Success, fail:@escaping Data.Fail) -> Void {
        Data.addCard(data: card.toData(nil, thumbImageURL: nil), callingViewController: callingViewController, success: { (response) in
            self.cards.append(card)
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
                        let card = CCCard(payload: cardDict as [String : AnyObject])
                        self.cards.append(card)
                    }
                    success(data)
                    return
                }
            }
        }, fail: { (data, response) in
            fail(data, response)
            
        })
    }
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
    
}
