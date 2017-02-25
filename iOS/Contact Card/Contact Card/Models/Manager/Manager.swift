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
    
    //MARK: - My Cards -
    var cards:[CCCard] = []
    
}
